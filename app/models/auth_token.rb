class AuthToken < ActiveRecord::Base
  MAX_NUM_AUTH_TOKENS = 5

  belongs_to :user

  validates :user_id, presence: true
  validates :encrypted_secret, presence: true

  before_validation :generate_secret, on: :create

  attr_reader :secret

  def self.encrypt_secret(secret)
    BCrypt::Password.create(secret, cost: 10).to_s
  end

  def self.by_secret(secret)
    all.find do |auth_token|
      auth_token.compare_secret(secret)
    end
  end

  def self.valid_secret?(secret)
    by_secret(secret).present?
  end

  def self.stale
    return none unless all.size >= MAX_NUM_AUTH_TOKENS

    fresh_auth_tokens = order(created_at: :desc)
                          .where('created_at >= ?', 30.days.ago)
                          .limit(MAX_NUM_AUTH_TOKENS - 1)
                          .pluck(:id)

    where.not(id: fresh_auth_tokens)
  end

  def compare_secret(secret)
    bcrypt = BCrypt::Password.new(encrypted_secret)
    secret = BCrypt::Engine.hash_secret(secret, bcrypt)

    Devise.secure_compare(encrypted_secret, secret)
  end

  def generate_secret
    @secret = Devise.friendly_token.to_s

    self.encrypted_secret = self.class.encrypt_secret(secret)
  end
end
