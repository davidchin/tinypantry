module Api
  module V1
    class FeedsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]

      before_action :find_feed, only: [:show, :update, :destroy]

      load_and_authorize_resource

      def index
        @feeds = Feed.all

        respond_with(:api, :v1, @feeds)
      end

      def show
        respond_with(:api, :v1, @feed)
      end

      def create
        @feed = Feed.create(feed_params)

        respond_with(:api, :v1, @feed)
      end

      def update
        @feed.update(feed_params)

        respond_with(:api, :v1, @feed)
      end

      def destroy
        respond_with(:api, :v1, @feed.destroy)
      end

      private

      def find_feed
        @feed = Feed.find(params[:id])
      end

      def feed_params
        params.require(:feed).permit(:name, :url, :rss)
      end
    end
  end
end
