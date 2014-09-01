class Shop < ActiveRecord::Base
  attr_accessible :name, :bling_key, :bling_api_version, :nfe_serie
  before_create :set_access_token

  validates :name, :bling_key, :presence => true
  validates :bling_api_version, :presence => true, inclusion: { :in => proc { self.api_versions } }

  def self.api_versions
    ["v1", "v2"]
  end

  protected

  def set_access_token
    self.access_token ||= SecureRandom.hex(32)
  end
end

