module Api
  module V1
    class RecipesController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show, :search, :related]

      before_action :find_recipes, only: [:index]
      before_action :find_recipe, only: [:show, :update, :destroy, :related]

      authorize_resource

      def index
        respond_with(@recipes) if stale? @recipes
      end

      def show
        respond_with(@recipe) if stale? @recipe
      end

      def search
        @recipes = Recipe.search_content(params[:query])

        respond_with(@recipes)
      end

      def related
        @recipes = @recipe.related_recipes

        respond_with(@recipes) if stale? @recipes
      end

      def create
        @recipe = Recipe.create(recipe_params)

        respond_with(@recipe)
      end

      def update
        @recipe.update(recipe_params)

        respond_with(@recipe)
      end

      def destroy
        respond_with(@recipe.destroy)
      end

      private

      def find_recipe
        @recipe = Recipe.friendly.find(params[:id])
      end

      def find_recipes
        if params[:category]
          @recipes = Recipe.by_category(params[:category])
                           .page(params[:page]).per(50)
        else
          @recipes = Recipe.page(params[:page]).per(50)
        end

        # Sort recipes
        @recipes =
          case params[:order_by]
          when 'bookmark'
            @recipes.most_bookmarked
          when 'view'
            @recipes.most_viewed
          else
            @recipes.most_recent
        end
      end

      def recipe_params
        params.require(:recipe)
              .permit(:name, :description, :url,
                      :image, :remote_image_url, :approved)
      end
    end
  end
end
