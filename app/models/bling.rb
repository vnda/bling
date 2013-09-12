#encoding: utf-8
require "builder"

class Bling
  def initialize(apikey)
    @apikey = apikey
  end

  def send(type, order)
    if type.present? && order.present?
      xml = generate_xml(order)
      response = send_to_bling(type, xml)
    else
      raise 'params missing'
    end
    response
  end

  def send_to_bling(type, xml)
    url = "http://www.bling.com.br"
    post_url = (type == 'nfe' ? '/recepcao.nfe.php' : '/recepcao.pedido.php')
    post_params = {
      :apiKey => @apikey,
      :pedidoXML => xml
    }
    require "faraday_middleware"
    connection = Faraday.new(url) do |builder|
      builder.request  :url_encoded
      builder.response :logger
      builder.adapter :net_http
    end

    response = connection.post post_url, post_params
    raise response.body unless response.body == 'OK'
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
            xml.tag!("codigo", [item["reference"], item["sku"]].join(' - '))
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
