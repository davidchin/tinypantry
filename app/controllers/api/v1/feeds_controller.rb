module Api
  module V1
    class FeedsController < ApplicationController
      before_action :authenticate_user!, only: [:create, :update, :destroy]

      def index
        @feeds = Feed.all

        respond_with(@feeds)
      end

      def show
        @feed = Feed.find(params[:id])

        respond_with(@feed)
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
