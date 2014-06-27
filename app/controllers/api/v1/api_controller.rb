class Api::V1::ApiController < ApplicationController
  respond_to :json

  check_authorization
  load_and_authorize_resource
end
