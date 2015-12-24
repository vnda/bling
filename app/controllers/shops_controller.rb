class ShopsController < ApplicationController
  def create
    if resource.save
      flash[:notice] = I18n.t(:create, :scope => [:flashes, :shop])
      redirect_to shops_url
    else
      render :new
    end
  end

  def update
    if resource.update_attributes(shop_params)
      flash[:notice] = I18n.t(:update, :scope => [:flashes, :shop])
      redirect_to shops_url
    else
      render :edit
    end
  end

  def destroy
    resource.destroy

    flash[:notice] = I18n.t(:destroy, :scope => [:flashes, :shop])
    redirect_to(request.referer || shops_url)
  end

  protected

  def collection
    @collection ||= begin
      shop = Shop.order("name")
      shop
    end
  end

  def resource
    @resource ||= if params[:id]
      Shop.find(params[:id])
    else
      Shop.new(shop_params)
    end
  end


  def shop_params
    return unless params[:shop]
    params.require(:shop).permit(:name, :bling_key, :bling_api_version, :bling_generate_nfe, :bling_generate_danfe, :nfe_serie)
  end
end
