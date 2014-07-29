class ErrorsController < ApplicationController
  def not_found
    respond_to do |format|
      format.json { render json: { error: 'Not Found', status: 404 }, status: 404 }
      format.html { render file: 'public/404.html', status: 404 }
    end
  end

  def unprocessable
    respond_to do |format|
      format.json { render json: { error: 'Unprocessable Entity', status: 422 }, status: 422 }
      format.html { render file: 'public/422.html', status: 422 }
    end
  end

  def error
    respond_to do |format|
      format.json { render json: { error: 'Application Error', status: 500 }, status: 500 }
      format.html { render file: 'public/500.html', status: 500 }
    end
  end
end
