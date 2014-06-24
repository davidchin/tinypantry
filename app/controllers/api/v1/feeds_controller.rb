class Api::V1::FeedsController < ApplicationController
  def index
    @feeds = Feed.all

    respond_with(@feeds)
  end

  def show
    @feed = Feed.find(params[:id])

    respond_with(@feed)
  end
end
