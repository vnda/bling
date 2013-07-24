#encoding: utf-8
require "builder"

class BlingController < ApplicationController
  def create
    if params[:order].present? && params[:type].present?
      order = MultiJson.load(params[:order])
      xml = generate_xml(order)
      response = send_to_bling(xml, params[:type])
    else
      response = {:status => 'error', :message => 'params missing'}
    end
    render :json => response
  end

  def send_to_bling(xml, type)
    report = {:status => 'error'}
    url = "http://www.bling.com.br"
    post_url = (type == 'nfe' ? '/recepcao.nfe.php' : '/recepcao.pedido.php')
    post_params = {
      :apiKey => "095ce0af267fce959dce5cdba481d8cabf891d8d",
      :pedidoXML => xml
    }
    require "faraday_middleware"
    connection = Faraday.new(url) do |builder|
      builder.request  :url_encoded
      builder.response :logger
      builder.adapter :net_http
    end

    begin
      response = connection.post post_url, post_params
    rescue Faraday::Error::ConnectionFailed
      report[:message] = 'connection failed'
    else
      if response.body == 'OK'
        report[:status] = 'success'
      else
        report[:message] = response.body
      end
    end

    return report
  end

  def generate_xml(order)
    xml = ::Builder::XmlMarkup.new(:indent => 2)
    xml.instruct!
    xml.tag!("pedido") do
      xml.tag!("cliente") do
        xml.tag!("nome", [order["first_name"], order["last_name"]].join(' '))
        xml.tag!("tipoPessoa", (order["cpf"].present? ? 'F' : 'J') )
        xml.tag!("cpf_cnpj", order["cpf"] || order["cnpj"])
        xml.tag!("ie_rg", order["rg"])  #need
        xml.tag!("endereco", order["street_name"])
        xml.tag!("numero", order["street_number"])
        xml.tag!("complemento", order["complement"]) #op
        xml.tag!("bairro", order["neighborhood"])
        xml.tag!("cep", order["zip"])
        xml.tag!("cidade", order["city"])
        xml.tag!("uf", order["state"])
        xml.tag!("fone", order["state"]) #op
        xml.tag!("email", order["email"])
      end
      xml.tag!("itens") do
        order["items"].each do |item|
          xml.tag!("item") do
            xml.tag!("codigo", [item["reference"], item["sku"]].join(' - ')) #op
            xml.tag!("descricao", [item["product_name"], item["variant_name"]].join(' - '))
            xml.tag!("un", 'un')  #need
            xml.tag!("qtde", item["quantity"])
            xml.tag!("vlr_unit", item["subtotal"])
            xml.tag!("tipo", 'P')  #need
            xml.tag!("peso_bruto", 0) #op  #need
            xml.tag!("peso_liq", 0) #op  #need
            xml.tag!("class_fiscal", '9999.99.99') #op  #need
            xml.tag!("origem", 0) #need
          end
        end
      end
      xml.tag!("vlr_frete", order["shipping_price"])
      xml.tag!("vlr_seguro", '') #op
      xml.tag!("vlr_despesas") #op
      xml.tag!("vlr_desconto", order["discount_price"])
      xml.tag!("obs", '') #op
    end
    xml.target!.tap { |str| logger.info(str) }
  end
end
