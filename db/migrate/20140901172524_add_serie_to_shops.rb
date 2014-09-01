class AddSerieToShops < ActiveRecord::Migration
  def change
    add_column :shops, :nfe_serie, :integer, default: 1
  end
end
