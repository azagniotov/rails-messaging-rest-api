require 'securerandom'

class User < ActiveRecord::Base
  before_create :set_auth_token
  before_save :encrypt_password
  after_save :clear_password

  validates :name, presence: true
  validates :email, presence: true
  validates :password, presence: true

  def self.authenticate(email, password)
    user = User.find_by(email: email)
    if user
      hashed_password = BCrypt::Password.new(user.password)
      if hashed_password == password then # the '==' method is overridden to perform hashing for us
        return user.auth_token
      end
    end
    nil
  end

  private
  def set_auth_token
    return if auth_token.present?
    self.auth_token = generate_auth_token
  end

  def generate_auth_token
    SecureRandom.uuid.gsub(/\-/,'')
  end

  def encrypt_password
    if password.present?
      self.salt = BCrypt::Engine.generate_salt
      self.password = BCrypt::Engine.hash_secret(password, salt)
    end
  end

  def clear_password
    self.password = nil
  end
end
