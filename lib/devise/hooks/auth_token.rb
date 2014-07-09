require 'devise/auth_token_header'

Warden::Manager.before_logout do |resource, warden|
  if resource.respond_to?(:destroy_auth_token!)
    auth_token_header = Devise::AuthTokenHeader.new(warden.request)

    if auth_token_header.valid?
      resource.destroy_auth_token!(auth_token_header.auth_token)
    end
  end
end
