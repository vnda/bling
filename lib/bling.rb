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
      xml.tag!("vlr_frete", order["shipping_price"])
      xml.tag!("vlr_desconto", order["discount_price"])
    end
    xml.target!.tap { |str| Rails.logger.info(str) }
  end
end
