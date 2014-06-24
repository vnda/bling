class Bling::Communicators::BlingV2Communicator
  attr_reader :bling_order_id
  ENDPOINT = "https://bling.com.br/Api/v2/" 

  def send_to_bling(type, xml, apikey)
    post_url = "#{ENDPOINT}#{type_path(type)}"
    post_params = {
      :apikey => apikey,
      :xml => xml
    }
    require "faraday_middleware"
    connection = Faraday.new(ENDPOINT) do |builder|
      builder.request  :url_encoded
      builder.adapter :net_http
      builder.response :json, :content_type => /\bjson$/
      end

    response = connection.post post_url, post_params
    @ok = response.body["retorno"]["erros"].blank?
    @bling_order_id = response.body["retorno"]["pedidos"].first["pedido"]["numero"] if ok?
    response

  end

  def ok?
    !!@ok
  end

  private
  def type_path(type)
    case type
    when "order"
      "/pedido/json"
    end
  end
end