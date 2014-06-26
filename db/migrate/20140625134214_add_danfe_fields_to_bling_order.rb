class AddDanfeFieldsToBlingOrder < ActiveRecord::Migration
  def change
    add_column :bling_orders, :bling_danfe_key, :string
    add_column :bling_orders, :bling_danfe_url, :string
  end
end
