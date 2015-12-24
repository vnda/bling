class Bling::Communicators::BlingV2Communicator
  attr_reader :bling_order_id, :bling_nfe_id, :bling_nfe_id, :bling_danfe_key, :bling_danfe_url

  ENDPOINT = "https://bling.com.br/Api/v2/"
  NFE_SERIE = 1

  def send_to_bling(type, xml, apikey, shop)
    @apikey = apikey

    begin
      response_order = save("order", xml)
      @bling_order_id = response_order.body["retorno"]["pedidos"].first["pedido"]["numero"]
      if shop.bling_generate_nfe?
        response_nfe = save("nfe", xml)
        @bling_nfe_id = response_nfe.body["retorno"]["notasfiscais"].first["notaFiscal"]["numero"]
        if shop.bling_generate_danfe?
          response_danfe = save("danfe", nil, @bling_nfe_id)
          @bling_danfe_key = response_danfe.body["retorno"]["notaFiscal"].first["chaveAcesso"]
          @bling_danfe_url = response_danfe.body["retorno"]["notaFiscal"].first["linkDanfe"]
        end
      end

      @ok = true
    rescue Exception => e
      @error_message = e.message
      @ok = false
    end
  end

  def ok?
    !!@ok
  end

  def save_bd?
    true
  end

  def error_message
    @error_message || ""
  end

  private

  def save(type, xml, nfe_number = nil)
    type_path = case type
                when "order"
                  "/pedido/json"
                when "nfe"
                  "/notafiscal/json"
                when "danfe"
                  danfe = true
                  "/notafiscal/json"
                end

    post_url = "#{ENDPOINT}#{type_path}"
    post_params = {
      :apikey => @apikey,
      :xml => xml
    }
    if danfe
      post_params[:serie] = NFE_SERIE
      post_params[:number] = nfe_number
    end
    connection = Faraday.new(ENDPOINT) do |builder|
      builder.request  :url_encoded
      builder.adapter :net_http
      builder.response :json, :content_type => /\bjson$/
    end

    response = connection.post post_url, post_params
    raise response.body["retorno"]["erros"].first[1] unless response.body["retorno"]["erros"].blank?
    response
  end

end
