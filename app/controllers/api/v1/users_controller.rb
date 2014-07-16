module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :authenticate_user!

      load_and_authorize_resource

      def index
        @users = User.all.page(params[:page])

        respond_with(:api, :v1, @users)
      end

      def show
        @user = User.find(params[:id])

        respond_with(:api, :v1, @user)
      end

      def update
        # TODO
      end

      def destroy
        # TODO
      end
    end
  end
end
