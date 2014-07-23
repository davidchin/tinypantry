module Api
  module V1
    class CategoriesController < Api::V1::ApiController
      before_action :authenticate_user!, except: [:index, :show]

      before_action :find_category, only: [:show, :update, :destroy]

      load_and_authorize_resource

      def index
        @categories = Category.all

        respond_with(:api, :v1, @categories)
      end

      def show
        respond_with(:api, :v1, @category)
      end

      def create
        @category = Category.create(params[:category])

        respond_with(:api, :v1, @category)
      end

      def update
        @category.update(params[:category])

        respond_with(:api, :v1, @category)
      end

      def destroy
        respond_with(:api, :v1, @category.destroy)
      end

      private

      def find_category
        @category = Category.find(params[:id])
      end
    end
  end
end
