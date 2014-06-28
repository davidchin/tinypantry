require 'devise/strategies/auth_token'

Warden::Strategies.add(:auth_token, Devise::Strategies::AuthToken)

Warden::Manager.before_logout do |user|
  user.destroy_auth_token! if user.respond_to?(:destroy_auth_token!)
end
