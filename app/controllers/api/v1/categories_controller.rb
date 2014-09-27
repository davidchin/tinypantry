module Api
  module V1
    class CategoriesController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :find_categories, only: [:index]
      before_action :find_category, only: [:show, :update, :destroy]

      wrap_parameters :category, include: [*Category.attribute_names, :keywords_attributes]

      authorize_resource

      def index
        respond_with(@categories) if stale? @categories
      end

      def show
        respond_with(@category) if stale? @category
      end

      def create
        @category = Category.create(category_params)

        respond_with(@category)
      end

      def update
        @category.update(category_params)

        respond_with(@category)
      end

      def destroy
        respond_with(@category.destroy)
      end

      private

      def find_categories
        @categories = Category.page(params[:page])
      end

      def find_category
        @category = Category.find(params[:id])
      end

      def category_params
        params.require(:category)
              .permit(:name, keywords_attributes: [:id, :name])
      end
    end
  end
end
