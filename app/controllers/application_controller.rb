class ApplicationController < ActionController::Base
  respond_to :html, :json, :json_v1

  protect_from_forgery with: :exception

  skip_before_action :verify_authenticity_token, if: :api_request?

  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  protected

  def api_request?
    request.format.json?
  end
end
