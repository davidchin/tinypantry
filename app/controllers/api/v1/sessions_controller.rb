module Api
  module V1
    class SessionsController < Devise::SessionsController
      def create
        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)
        respond_with(resource, methods: :auth_token)
      end
    end
  end
end
