class AddShopIdToBlingOrders < ActiveRecord::Migration
  def change
    add_column :bling_orders, :shop_id, :integer
  end
end
