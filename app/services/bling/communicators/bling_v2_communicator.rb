class Bling::Communicators::BlingV2Communicator
  attr_reader :bling_order_id
  attr_reader :bling_nfe_id
  ENDPOINT = "https://bling.com.br/Api/v2/" 

  def send_to_bling(type, xml, apikey)
    @apikey = apikey

    response_order = save("order", xml)
    @ok = response_order.body["retorno"]["erros"].blank?
    return response_order unless ok?
    @bling_order_id = response_order.body["retorno"]["pedidos"].first["pedido"]["numero"]

    response_nfe = save("nfe", xml)
    @ok = response_nfe.body["retorno"]["erros"].blank?
    @bling_nfe_id = response_nfe.body["retorno"]["notasfiscais"].first["notaFiscal"]["numero"]
    response_nfe.body
  end

  def ok?
    !!@ok
  end

  def save_bd?
    true
  end

  private

  def save(type, xml)
    type_path = case type
                when "order"
                  "/pedido/json"
                when "nfe"
                  "/notafiscal/json"
                end

    post_url = "#{ENDPOINT}#{type_path}"
    post_params = {
      :apikey => @apikey,
      :xml => xml
    }
    connection = Faraday.new(ENDPOINT) do |builder|
      builder.request  :url_encoded
      builder.adapter :net_http
      builder.response :json, :content_type => /\bjson$/
      end

    connection.post post_url, post_params
  end

end