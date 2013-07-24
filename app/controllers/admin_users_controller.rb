class AdminUsersController < ApplicationController
  def create
    if resource.save
      redirect_to admin_users_url
    else
      render :new
    end
  end

  def update
    params[:user].delete(:password) if params[:user][:password].blank?

    if resource.update_attributes(params[:user])
      redirect_to admin_users_url
    else
      render :edit
    end
  end

  def destroy
    resource.destroy
    redirect_to admin_users_url
  end

  protected

  def collection
    @collection ||= AdminUser.scoped.page(params[:page])
  end

  def resource
    @resource ||= if params[:id]
      AdminUser.find(params[:id])
    else
      AdminUser.new((params[:user] || {}).except(:shop_id)).tap do |u|
        u.shop_id = params[:user][:shop_id] if params[:user] && params[:user][:shop_id]
      end
    end
  end
end
