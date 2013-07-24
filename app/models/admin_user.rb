class AdminUser < ActiveRecord::Base
  attr_accessor :password, :password_confirmation
  attr_accessible :email, :password, :password_confirmation

  validates_presence_of :email
  validates_confirmation_of :password
  validates :email, :email => true

  before_save :encrypt_password

  def password_match?(password)
    password_hash == AdminUser.encrypt_password(password, password_salt)
  end

  def self.authenticate(email, password)
    record = scoped.where(:email => email).first
    return nil unless record.respond_to?(:password_hash)
    return nil unless record.password_hash == encrypt_password(password, record.password_salt)
    record
  end

  protected

  def encrypt_password
    self.password_salt = Digest::SHA256.hexdigest([Time.to_s, SecureRandom.hex(32)].join("--"))
    self.password_hash = self.class.encrypt_password(password, password_salt)
  end

  def self.encrypt_password(password, salt)
    Digest::SHA256.hexdigest([password, salt].join("--"))
  end
end

