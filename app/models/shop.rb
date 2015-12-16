class Shop < ActiveRecord::Base
  attr_accessible :name, :bling_key, :bling_api_version, :bling_generate_nfe, 
                                                         :bling_generate_danfe, :nfe_serie
  before_create :set_access_token

  validates :name, :bling_key, :presence => true
  validates :bling_api_version, :presence => true, inclusion: { :in => proc { self.api_versions } }
  validate :validate_danfe

  def self.api_versions
    ["v1", "v2"]
  end
  
  def validate_danfe
    if self.bling_generate_nfe.blank? && self.bling_generate_danfe
      errors.add(:bling_generate_danfe, :nfe_presence)
    end
  end

  protected

  def set_access_token
    self.access_token ||= SecureRandom.hex(32)
  end
end
