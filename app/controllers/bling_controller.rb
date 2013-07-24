#encoding: utf-8
require 'bling'

class BlingController < ApplicationController
  skip_filter :authenticate!, :only => [:create]

  def create
    if params[:token].blank?
      render :json => {:error => 'token missing'}
    else
      access_token = params[:token].gsub(/[^0-9A-Za-z]/, '')
      if shop = Shop.where(:access_token => access_token).first
        order = MultiJson.load(request.body.read || '{}')
        bling = Bling.new(shop.bling_key)
        render :json => bling.send('order', order)
      else
        render :json => {:error => 'invalid token'}
      end
    end
  end
end
