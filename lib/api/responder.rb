module Api
  class Responder < ActionController::Responder
    protected

    def api_location
      options[:location]
    end
  end
end
