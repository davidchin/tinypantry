class User < ActiveRecord::Base
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_and_belongs_to_many :roles

  has_many :auth_tokens, dependent: :destroy

  has_many :bookmarks, dependent: :destroy
  has_many :bookmarked_recipes, through: :bookmarks, source: :recipe

  attr_reader :auth_token_secret

  def role?(role_symbol)
    roles.find_by(name: role_symbol.to_s.camelize).present?
  end

  def generate_auth_token!
    auth_tokens.stale.destroy_all

    auth_token = auth_tokens.create
    @auth_token_secret = auth_token.secret
  end

  def destroy_auth_token!(secret)
    auth_tokens.by_secret(secret).try(:destroy)
  end

  def valid_auth_token?(secret)
    auth_tokens.valid_secret?(secret)
  end
end
