module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)

        respond_with(resource, methods: :auth_token_secret,
                               location: after_sign_in_path_for(resource))
      end

      def destroy
        self.resource = warden.authenticate(auth_options)
        super
      end
    end
  end
end
