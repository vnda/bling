#encoding: utf-8
class BlingController < ApplicationController
  skip_filter :authenticate!, :only => [:create]

  def create
    raise "token missing" if params[:token].blank?
    access_token = params[:token].gsub(/[^0-9A-Za-z]/, '')
    shop = Shop.where(:access_token => access_token).first
    raise "token not found" unless shop

    body = request.body.read
    raise "request body is empty" if body.blank?
    order = MultiJson.load(body)

    bling = Bling.new(shop.bling_key, shop.bling_api_version)
    render :json => bling.send('order', order)
  end
end
