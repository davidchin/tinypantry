module Api
  module V1
    class PasswordsController < Devise::PasswordsController
      respond_to :json

      wrap_parameters :user
    end
  end
end
