class AddGenerateNfeAndDanfeToShop < ActiveRecord::Migration
  def change
    add_column :shops, :bling_generate_nfe, :boolean, default: true
    add_column :shops, :bling_generate_danfe, :boolean, default: true
  end
end
