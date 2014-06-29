module Devise
  module Strategies
    class AuthToken < Base
      def valid?
        params[:email].present? && params[:auth_token].present?
      end

      def authenticate!
        user = User.find_by(email: params[:email])

        if user && user.valid_auth_token?(params[:auth_token])
          success!(user)
        else
          fail
        end
      end

      def store?
        false
      end
    end
  end
end

Warden::Strategies.add(:auth_token, Devise::Strategies::AuthToken)
