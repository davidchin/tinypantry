module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json

      prepend_before_action :skip_devise_trackable

      load_and_authorize_resource
      check_authorization

      private

      def skip_devise_trackable
        request.env['devise.skip_trackable'] = true
      end
    end
  end
end
