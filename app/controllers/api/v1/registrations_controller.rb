module Api
  module V1
    class RegistrationsController < Devise::RegistrationsController
      respond_to :json

      wrap_parameters :user
    end
  end
end
