#encoding: utf-8
require 'bling'

class BlingController < ApplicationController
  skip_filter :authenticate!, :only => [:create]
  before_filter :authenticate_by_token!, :only => [:create]

  def create
    order = MultiJson.load(params[:order] || '{}')
    token = Shop.where(:access_token => current_access_token).pluck(:bling_key).first
    bling = Bling.new(token)
    render :json => bling.send(params[:type], order)
  end
end
