class RecipesController < ApplicationController
  def index
    if params[:category]
      @category = Category.find_by(name: params[:category])
      @recipes = @category.recipes.page(params[:page]).per(50)
    else
      @recipes = Recipe.page(params[:page]).per(50)
    end

    respond_with(@recipes)
  end

  def show
    @recipe = Recipe.find(params[:id])

    respond_with(@recipe)
  end
end
