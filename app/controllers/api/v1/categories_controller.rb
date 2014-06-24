class Api::V1::CategoriesController < Api::V1::ApiController
  def index
    @categories = Category.all

    respond_with(@categories)
  end
end
