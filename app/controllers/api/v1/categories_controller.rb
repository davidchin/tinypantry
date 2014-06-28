module Api
  module V1
    class CategoriesController < Api::V1::ApiController
      def index
        @categories = Category.all

        respond_with(@categories)
      end
    end
  end
end
