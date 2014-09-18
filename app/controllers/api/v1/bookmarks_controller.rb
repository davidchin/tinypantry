module Api
  module V1
    class BookmarksController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :recipes]

      before_action :find_user

      set_pagination_header :bookmarks, only: [:index, :search]

      authorize_resource

      def index
        @bookmarks = @user.bookmarks.page(params[:page])

        respond_with(@bookmarks) if stale? @bookmarks
      end

      def recipes
        @recipes = @user.bookmarked_recipes
                        .order_by(params[:order_by])

        respond_with(@recipes) if stale? @recipes
      end

      def search_recipes
        @recipes = @user.bookmarked_recipes
                        .search_content(params[:query])
                        .order_by(params[:order_by])

        respond_with(@recipes)
      end

      def summary
        @bookmarks = @user.bookmarks

        respond_with(@bookmarks) if stale? @bookmarks
      end

      def create
        @bookmark = @user.bookmarks.create!(bookmark_params)

        respond_with(@bookmark)
      end

      def destroy
        @bookmark = @user.bookmarks.find_by(bookmark_params)

        respond_with(@bookmark.destroy!)
      end

      private

      def find_user
        @user = User.find(params[:user_id])
      end

      def bookmark_params
        params.require(:bookmark)
              .permit(:recipe_id, :user_id)
      end
    end
  end
end
