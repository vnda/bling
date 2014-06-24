#encoding: utf-8
require "builder"
class Bling
  def initialize(apikey, api_version)
    @apikey = apikey
    @api_version = api_version
  end

  def send(type, order)
    @order = order
    if type.present? && @order.present?
      xml = generate_xml(@order)
      response = send_to_bling(type, xml)
    else
      raise 'params missing'
    end
    response
  end

  def send_to_bling(type, xml)
    communicator = Bling::BlingCommunicator.new(@api_version, @apikey)
    response = communicator.send_to_bling(type, xml)
    if communicator.save_bd?
      raise "Error on save BlingOrder to database" unless BlingOrder.create(:vnda_order_id => @order["id"],
                                                                             :bling_order_id => communicator.bling_order_id,
                                                                             :bling_nfe_id => communicator.bling_nfe_id  )
    end
    raise response.body unless communicator.ok?
    true
  end

  def generate_xml(order)
    xml = ::Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    xml.tag!("pedido") do
      xml.tag!("cliente") do
        xml.tag!("nome", [order["first_name"], order["last_name"]].join(' '))
        xml.tag!("tipoPessoa", (order["cpf"].present? ? 'F' : 'J') )
        xml.tag!("cpf_cnpj", order["cpf"] || order["cnpj"])
        xml.tag!("ie_rg", order["rg"])
        xml.tag!("endereco", order["street_name"])
        xml.tag!("numero", order["street_number"])
        xml.tag!("complemento", order["complement"])
        xml.tag!("bairro", order["neighborhood"])
        xml.tag!("cep", order["zip"])
        xml.tag!("cidade", order["city"])
        xml.tag!("uf", order["state"])
        xml.tag!("email", order["email"])
        if order["cellphone"].present?
          xml.tag!("fone", [order["cellphone_area"], order["cellphone"]].join(''))
        elsif
          xml.tag!("fone", [order["phone_area"], order["phone"]].join(''))
        end
      end
      xml.tag!("itens") do
        order["items"].each do |item|
          xml.tag!("item") do
            xml.tag!("codigo", item["sku"])
            xml.tag!("descricao", [item["product_name"], item["variant_name"]].join(' - '))
            xml.tag!("un", 'un')
            xml.tag!("qtde", item["quantity"])
            xml.tag!("vlr_unit", item["subtotal"])
            xml.tag!("tipo", 'P')
            xml.tag!("origem", 0)
          end
        end
      end
      xml.tag!("parcelas") do
        total = installments(order["total"], order["installments"].to_i)
        order["installments"].to_i.times do |index|
          xml.tag!("parcela") do
            xml.tag!("dias", ((index) * 30) )
            xml.tag!("data", (order["confirmed_at"].to_date + index.month).strftime("%d/%m/%Y"))
            xml.tag!("vlr", total )
          end
        end
      end
      xml.tag!("vlr_frete", order["shipping_price"])
      xml.tag!("vlr_desconto", order["discount_price"])
    end
    xml.target!.tap { |str| Rails.logger.info(str) }
  end

  def installments(value, times)
    return value if times == 1
    value = BigDecimal.new(value.to_s)
    price = (value / times).round(2)
    price = (value / (times -= 1)).round(2) while price < 5
    price.to_f
  end
end
