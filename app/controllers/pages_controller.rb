class PagesController < ApplicationController
  def app
    render text: '', layout: 'application'
  end
end
