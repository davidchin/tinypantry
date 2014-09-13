require 'api/responder'

module Api
  module V1
    class ApiController < ApplicationController
      respond_to :json, :json_v1

      prepend_before_action :skip_devise_trackable

      check_authorization

      self.responder = Api::Responder

      protected

      def self.set_pagination_header(name, options = {})
        after_action(options) do
          scope = instance_variable_get("@#{ name }")

          headers['Pagination'] = {
            total_items: scope.count(:all),
            total_pages: scope.total_pages,
            current_page: scope.current_page,
            previous_page: (scope.current_page - 1 unless scope.first_page?),
            next_page: (scope.current_page + 1 unless scope.last_page?)
          }.to_json
        end
      end

      def skip_devise_trackable
        request.env['devise.skip_trackable'] = true
      end
    end
  end
end
