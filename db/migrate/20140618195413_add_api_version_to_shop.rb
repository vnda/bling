class AddApiVersionToShop < ActiveRecord::Migration
  def change
    add_column :shops, :bling_api_version, :string, default: "v1"
  end
end
