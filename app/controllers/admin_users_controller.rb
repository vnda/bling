class AdminUsersController < ApplicationController
  before_filter :authenticate!

  def create
    if resource.save
      flash[:notice] = I18n.t(:create, :scope => [:flashes, :admin_user])
      redirect_to admin_users_url
    else
      render :new
    end
  end

  def update
    params[:admin_user].delete("password") if params[:admin_user][:password].blank?
    params[:admin_user].delete("password_confirmation") if params[:admin_user][:password].blank?

    if resource.update_attributes(params[:admin_user])
      flash[:notice] = I18n.t(:update, :scope => [:flashes, :admin_user])
      redirect_to admin_users_url
    else
      render :edit
    end
  end

  def destroy
    resource.destroy

    flash[:notice] = I18n.t(:destroy, :scope => [:flashes, :admin_user])
    redirect_to admin_users_url
  end

  protected

  def collection
    @collection ||= AdminUser.order(:email)
  end

  def resource
    @resource ||= if params[:id]
      AdminUser.find(params[:id])
    else
      AdminUser.new(params[:admin_user])
    end
  end
end
