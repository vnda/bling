class Bling::Communicators::BlingV1Communicator
  def send_to_bling(type, xml, apikey)
    url = "http://www.bling.com.br"
    post_url = (type == 'nfe' ? '/recepcao.nfe.php' : '/recepcao.pedido.php')
    post_params = {
      :apiKey => apikey,
      :pedidoXML => xml
    }
    connection = Faraday.new(url) do |builder|
      builder.request  :url_encoded
      builder.response :logger
      builder.adapter :net_http
    end

    @response = connection.post post_url, post_params
    @ok = @response.body == 'OK'

  end

  def ok?
    !!@ok
  end

  def save_bd?
    false
  end  

  def error_message
    @response.body
  end
end