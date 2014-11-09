module Api
  module V1
    class RecipesController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show, :search, :related]
      before_action :find_recipes, only: [:index]
      before_action :find_recipe, only: [:show, :update, :destroy, :related]

      set_pagination_header :recipes, only: [:index, :search, :related]

      authorize_resource

      def index
        respond_with(@recipes) if stale? @recipes
      end

      def show
        respond_with(@recipe) if stale? @recipe
      end

      def search
        @recipes = Recipe.search_content(params[:query])
                         .page(params[:page])
                         .order_by(params[:order_by])

        respond_with(@recipes) do |format|
          format.json { render :index }
        end
      end

      def related
        @recipes = @recipe.related_recipes
                          .approved
                          .page(params[:page])
                          .order_by(params[:order_by])

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
        @recipe = Recipe
        @recipe = @recipe.approved unless can?(:manage, :recipe)
        @recipe = @recipe.friendly.find(params[:id])
      end

      def find_recipes
        @recipes = Recipe
        @recipes = @recipes.approved unless can?(:manage, :recipe)
        @recipes = @recipes.by_category(params[:category]) if params[:category]
        @recipes = @recipes.order_by(params[:order_by]).page(params[:page])
      end

      def recipe_params
        params.require(:recipe)
              .permit(:name, :description, :url,
                      :image, :remote_image_url, :approved)
      end
    end
  end
end
