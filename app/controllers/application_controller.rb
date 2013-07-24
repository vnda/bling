class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate!
  helper_method :current_user, :resource, :collection, :signed_in?

  def redirect_back_or_default(default_url)
    redirect_to (session[:return_to] || default_url)
    session[:return_to] = nil
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        AdminUser.where(:id => session[:user_id]).first
      end
    end
  end

  def signed_in?
    (current_user && !current_user.renew_password?)
  end

  protected

  def authenticate!
    unless signed_in?
      session[:return_to] =  request.url
      redirect_to(login_url)
    end
  end
end
