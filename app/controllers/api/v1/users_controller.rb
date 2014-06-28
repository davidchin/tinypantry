module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :authenticate_user!

      def index
        @users = User.all.page(params[:page])

        respond_with(@users)
      end

      def show
        @user = User.find(params[:id])

        respond_with(@user)
      end

      def update
      end

      def destroy
      end
    end
  end
end
