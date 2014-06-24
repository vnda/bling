class CreateBlingOrders < ActiveRecord::Migration
  def change
    create_table :bling_orders do |t|
      t.integer :vnda_order_id
      t.integer :bling_order_id
      t.integer :bling_nfe_id

      t.timestamps
    end
    add_index :bling_orders, :vnda_order_id
    add_index :bling_orders, :bling_order_id
    add_index :bling_orders, :bling_nfe_id
  end
end
