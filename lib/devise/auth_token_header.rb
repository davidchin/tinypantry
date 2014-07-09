module Devise
  class AuthTokenHeader
    def initialize(request)
      @request = request
    end

    def auth_token
      @auth_token ||= token_and_options.first
      @auth_token ||= @request.params[:auth_token]
    end

    def email
      @email ||= token_and_options.second && token_and_options.second[:email]
      @email ||= @request.params[:email]
    end

    def valid?
      email.present? && auth_token.present?
    end

    private

    def token_and_options
      ActionController::HttpAuthentication::Token.token_and_options(@request) || []
    end
  end
end
