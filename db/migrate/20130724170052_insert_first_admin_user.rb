class InsertFirstAdminUser < ActiveRecord::Migration
  def up
    AdminUser.create(:email => 'francisco@vnda.com.br', :password => '123456')
  end

  def down
    AdminUser.delete_all
  end
end
