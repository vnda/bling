#encoding: utf-8
class BlingController < ApplicationController
  skip_filter :authenticate!, :only => [:create, :danfe]

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

  def danfe
    raise "order id missing" if params[:order_id].blank?
    bling_order = BlingOrder.where(:vnda_order_id => params[:order_id]).first
    unless bling_order
      render :nothing => true, :status => 204
      return
    end
    render :json => { :danfe_url => bling_order.bling_danfe_url }
  end
end
