require 'bcrypt'

class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :bookmarks, source: :recipe

  before_save :ensure_auth_token

  attr_accessor :auth_token

  def role?(role_symbol)
    roles.find_by(name: role_symbol.to_s.camelize).present?
  end

  def ensure_auth_token
    self.encrypted_auth_token ||= generate_auth_token
  end

  def destroy_auth_token!
    self.encrypted_auth_token = nil
    save(validate: false)
  end

  def valid_auth_token?(auth_token)
    bcrypt = BCrypt::Password.new(encrypted_auth_token)
    auth_token = BCrypt::Engine.hash_secret(auth_token, bcrypt)
    Devise.secure_compare(encrypted_auth_token, auth_token)
  end

  def self.encrypt_auth_token(auth_token)
    BCrypt::Password.create(auth_token, cost: 10).to_s
  end

  private

  def generate_auth_token
    loop do
      self.auth_token = Devise.friendly_token
      token = User.encrypt_auth_token(auth_token)
      break token unless User.exists?(encrypted_auth_token: token)
    end
  end
end
