module Api
  module V1
    class RecipesController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show, :related]

      before_action :find_recipes, only: [:index]
      before_action :find_recipe, only: [:show, :update, :destroy, :related]

      load_and_authorize_resource

      def index
        respond_with(:api, :v1, @recipes)
      end

      def show
        respond_with(:api, :v1, @recipe)
      end

      def search
        @recipes = Recipe.search_content(params[:query])

        respond_with(:api, :v1, @recipes)
      end

      def related
        @recipes = @recipe.related_recipes

        respond_with(:api, :v1, @recipes)
      end

      def create
        @recipe = Recipe.create(params[:recipe])

        respond_with(:api, :v1, @recipe)
      end

      def update
        @recipe.update(params[:recipe])

        respond_with(:api, :v1, @recipe)
      end

      def destroy
        respond_with(:api, :v1, @recipe.destroy)
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
