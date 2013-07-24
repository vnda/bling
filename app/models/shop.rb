class Shop < ActiveRecord::Base
  attr_accessible :name, :bling_key
  before_create :set_access_token

  validates :name, :bling_key, :presence => true

  protected

  def set_access_token
    self.access_token ||= SecureRandom.hex(32)
  end
end

