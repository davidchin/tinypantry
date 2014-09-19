module Api
  module V1
    class BookmarksController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index]
      before_action :find_user

      set_pagination_header :bookmarks, only: [:index]

      authorize_resource

      def index
        @bookmarks = @user.bookmarks.page(params[:page])

        respond_with(@bookmarks) if stale? @bookmarks
      end

      def summary
        @bookmarks = @user.bookmarks

        respond_with(@bookmarks) if stale? @bookmarks
      end

      def create
        @bookmark = @user.bookmarks.create!(recipe_id: params[:recipe_id])

        respond_with(@bookmark)
      end

      def destroy
        @bookmark = @user.bookmarks.find(params[:id])

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
