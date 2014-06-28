module Api
  module V1
    class RecipesController < Api::V1::ApiController
      before_action :authenticate_user!, only: [:bookmark, :create, :update, :destroy]

      before_action :find_recipes, only: [:index]
      before_action :find_recipe, only: [:show, :related]

      def index
        respond_with(@recipes)
      end

      def show
        respond_with(@recipe)
      end

      def search
        @recipes = Recipe.search_content(params[:q])

        respond_with(@recipes)
      end

      def related
        @recipes = @recipe.related_recipes

        respond_with(@recipes)
      end

      def bookmark
      end

      def create
      end

      def update
      end

      def destroy
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
      end
    end
  end
end
