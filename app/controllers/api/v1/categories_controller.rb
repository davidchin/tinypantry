module Api
  module V1
    class CategoriesController < Api::V1::ApiController
      before_action :authenticate_user!, only: [:create, :update, :destroy]

      def index
        @categories = Category.all

        respond_with(@categories)
      end

      def show
        @category = Category.find(params[:id])

        respond_with(@category)
      end

      def create
      end

      def update
      end

      def destroy
      end
    end
  end
end
