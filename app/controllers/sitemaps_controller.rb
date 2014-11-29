class SitemapsController < ActionController::Base
  layout nil

  def show
    @recipes = Recipe.approved
    @categories = Category.all
  end
end
