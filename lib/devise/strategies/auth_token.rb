module Devise
  module Strategies
    class AuthToken < Base
      def valid?
        params[:email].present? && params[:auth_token].present?
      end

      def authenticate!
        user = User.find_by(email: params[:email])
        auth_token = User.encrypt_auth_token(params[:auth_token])

        if user && Devise.secure_compare(user.encrypted_auth_token, auth_token)
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
