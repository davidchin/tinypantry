module Api
  module V1
    class FeedsController < ApplicationController
      before_action :authenticate_user!, only: [:create, :update, :destroy]

      load_and_authorize_resource

      def index
        @feeds = Feed.all

        respond_with(@feeds)
      end

      def show
        @feed = Feed.find(params[:id])

        respond_with(@feed)
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
