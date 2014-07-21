module Api
  module V1
    class UsersController < Api::V1::ApiController
      before_action :authenticate_user!

      before_action :find_user, except: [:index]

      load_and_authorize_resource

      def index
        @users = User.all.page(params[:page])

        respond_with(:api, :v1, @users)
      end

      def show
        respond_with(:api, :v1, @user)
      end

      def update
        # TODO
      end

      def destroy
        # TODO
      end

      def bookmarks
        @bookmarks = @user.bookmarks

        respond_with(:api, :v1, @bookmarks)
      end

      def bookmarked_recipes
        @bookmarked_recipes = @user.bookmarked_recipes.page(params[:page])

        respond_with(:api, :v1, @bookmarked_recipes)
      end

      private

      def find_user
        @user = User.find(params[:id])
      end
    end
  end
end
