class CreateShops < ActiveRecord::Migration
  def change
    create_table :shops do |t|
      t.string :name, :null => false
      t.string :access_token, :null => false
      t.string :bling_key, :null => false

      t.timestamps
    end
  end
end
