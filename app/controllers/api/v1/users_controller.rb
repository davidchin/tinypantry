module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :find_user, only: [:show, :update, :destroy]

      set_pagination_header :users, only: [:index]

      authorize_resource

      def index
        @users = User.all.page(params[:page])

        respond_with(@users) if stale? @users
      end

      def show
        respond_with(@user) if stale? @user
      end

      def update
        @user.update(params[:user])

        respond_with(@user)
      end

      def destroy
        respond_with(@user.destroy)
      end

      private

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
