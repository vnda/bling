class BlingOrder < ActiveRecord::Base
  attr_accessible :bling_nfe_id, :bling_order_id, :vnda_order_id, :bling_danfe_key, :bling_danfe_url

  validates :bling_nfe_id, :bling_order_id, :vnda_order_id, :bling_danfe_key, :bling_danfe_url, :presence => true
end
