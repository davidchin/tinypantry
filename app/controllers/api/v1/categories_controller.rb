module Api
  module V1
    class CategoriesController < Api::V1::ApiController
      before_action :authenticate_user!, only: [:create, :update, :destroy]

      load_and_authorize_resource

      def index
        @categories = Category.all

        respond_with(@categories)
      end

      def show
        @category = Category.find(params[:id])

        respond_with(@category)
      end

      def create
        # TODO
      end

      def update
        # TODO
      end

      def destroy
        # TODO
      end
    end
  end
end
