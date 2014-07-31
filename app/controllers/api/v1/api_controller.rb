require 'api/responder'

module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json, :json_v1

      prepend_before_action :skip_devise_trackable

      check_authorization

      self.responder = Api::Responder

      private

      def skip_devise_trackable
        request.env['devise.skip_trackable'] = true
      end
    end
  end
end
