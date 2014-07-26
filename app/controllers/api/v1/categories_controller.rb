module Api
  module V1
    class CategoriesController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :find_category, only: [:show, :update, :destroy]

      wrap_parameters :category, include: [*Category.attribute_names, :keywords_attributes]

      load_and_authorize_resource

      def index
        @categories = Category.all

        respond_with(:api, :v1, @categories)
      end

      def show
        respond_with(:api, :v1, @category)
      end

      def create
        @category = Category.create(category_params)

        respond_with(:api, :v1, @category)
      end

      def update
        @category.update(category_params)

        respond_with(:api, :v1, @category)
      end

      def destroy
        respond_with(:api, :v1, @category.destroy)
      end

      private

      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category).permit(:name, keywords_attributes: [:id, :name])
      end
    end
  end
end
