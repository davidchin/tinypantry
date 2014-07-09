require 'devise/auth_token_header'

module Devise
  module Strategies
    class AuthToken < Base
      def valid?
        auth_token_header.valid?
      end

      def authenticate!
        user = User.find_by(email: auth_token_header.email)

        if user && user.valid_auth_token?(auth_token_header.auth_token)
          success!(user)
        else
          fail
        end
      end

      def store?
        false
      end

      private

      def auth_token_header
        @auth_token_header ||= Devise::AuthTokenHeader.new(request)
      end
    end
  end
end

Warden::Strategies.add(:auth_token, Devise::Strategies::AuthToken)
