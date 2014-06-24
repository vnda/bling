class BlingOrder < ActiveRecord::Base
  attr_accessible :bling_nfe_id, :bling_order_id, :vnda_order_id

  validates :bling_nfe_id, :bling_order_id, :vnda_order_id, :presence => true
end
