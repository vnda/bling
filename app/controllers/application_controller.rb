class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate! if ENV["HTTP_USER"] && ENV["HTTP_PASSWORD"]
  helper_method :current_user, :resource, :collection, :signed_in?

  def status
    render text: 'OK'
  end

  protected

  def authenticate!
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["HTTP_USER"] && password == ENV["HTTP_PASSWORD"]
    end
  end
end
