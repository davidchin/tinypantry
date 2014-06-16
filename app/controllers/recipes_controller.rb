class RecipesController < ApplicationController
  def index
    @recipes = Recipes.page(params[:page]).per(50)
  end

  def show
    @recipe = Recipe.find(params[:id])
  end
end
