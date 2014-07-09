module Api
  module V1
    class SessionsController < Devise::SessionsController
      respond_to :json

      skip_before_action :skip_devise_trackable, only: :create

      wrap_parameters :user

      def create
        # Skip storage
        request.env['devise.skip_storage'] = true

        self.resource = warden.authenticate!(auth_options)
        sign_in(resource_name, resource)

        # Generate a new auth token and destroy stale tokens
        resource.generate_auth_token! if resource.respond_to?(:generate_auth_token!)

        respond_with(resource, methods: :auth_token_secret,
                               location: after_sign_in_path_for(resource))
      end

      def destroy
        self.resource = warden.authenticate(auth_options)
        super
      end

      def verify
        resource = warden.authenticate!(auth_options)

        respond_with(resource, only: :email)
      end
    end
  end
end
