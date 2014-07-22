module Api
  module V1
    class BookmarksController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :recipes]

      before_action :find_user

      load_and_authorize_resource

      def index
        @bookmarks = @user.bookmarks

        respond_with(:api, :v1, @bookmarks)
      end

      def create
        @bookmark = @user.bookmarks.create!(recipe_id: params[:recipe_id])

        respond_with(:api, :v1, @bookmark)
      end

      def destroy
        @bookmark = @user.bookmarks.find_by(recipe_id: params[:recipe_id])

        respond_with(:api, :v1, @bookmark.destroy!)
      end

      def recipes
        @recipes = @user.bookmarked_recipes.page(params[:page])

        respond_with(:api, :v1, @recipes)
      end

      private

      def find_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
