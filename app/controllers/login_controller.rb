# encoding: utf-8
class LoginController < ApplicationController
  skip_filter :authenticate!, :only => [:new, :create, :renew_password, :set_password]

  def new
    redirect_to root_url if signed_in?
  end

  def create
    user = AdminUser.authenticate(params[:user][:email], params[:user][:password])
    if user
      session[:user_id] = user.id

      if user.renew_password?
        redirect_to(renew_password_url)
      else
        redirect_back_or_default(root_url)
      end
    else
      flash[:notice] = 'Não foi possível confirmar seus dados.'
      render :new
    end
  end

  def destroy
    session.delete(:user_id)
    redirect_to(login_url)
  end

  def renew_password
    if !current_user || (current_user && !current_user.renew_password?)
      redirect_to root_url
    end
  end

  def set_password
    if signed_in?
      redirect_to(root_url)
    else
      current_user.password = params[:user][:password]
      current_user.password_confirmation = params[:user][:password_confirmation]
      current_user.renew_password = false

      unless current_user.save
        render :action => "renew_password"
      end
    end

    redirect_to(root_url) unless performed?
  end

  protected

  def resource
    @resource ||= AdminUser.new(params[:user])
  end
end
