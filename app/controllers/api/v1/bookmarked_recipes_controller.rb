module Api
  module V1
    class BookmarkedRecipesController < Api::V1::ApiController
      before_action :find_user
      before_action :find_recipes, only: [:index, :search]

      set_pagination_header :recipes, only: [:index, :search]

      authorize_resource :recipe

      def index
        @recipes = @recipes.order_by(params[:order_by])
                           .page(params[:page])

        respond_with(@recipes) if stale? @recipes
      end

      def search
        @recipes = @recipes.search_content(params[:query])
                           .order_by(params[:order_by])
                           .page(params[:page])

        respond_with(@recipes) do |format|
          format.json { render :index }
        end
      end

      private

      def find_recipes
        @recipes = @user.bookmarked_recipes
        @recipes = @recipes.approved unless can?(:manage, :recipe)
      end

      def find_user
        @user = User.find(params[:user_id])
      end
    end
  end
end
