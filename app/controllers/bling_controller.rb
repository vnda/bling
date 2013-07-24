#encoding: utf-8
require 'bling'

class BlingController < ApplicationController
  def create
    order = MultiJson.load(params[:order] || '{}')
    bling = Bling.new('095ce0af267fce959dce5cdba481d8cabf891d8d')
    render :json => bling.send(params[:type], order)
  end
end
