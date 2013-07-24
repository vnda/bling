class CreateAdminUser < ActiveRecord::Migration
  def change
    create_table "admin_users", :force => true do |t|
      t.string   "email",          :default => "",    :null => false
      t.string   "password_salt"
      t.string   "password_hash"
      t.boolean  "renew_password", :default => false, :null => false

      t.timestamps
    end
  end
end
