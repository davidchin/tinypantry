module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        respond_with(resource, methods: :auth_token,
                               location: after_sign_in_path_for(resource))
      end
    end
  end
end
