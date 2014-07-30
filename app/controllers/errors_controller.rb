class ErrorsController < ActionController::Base
  def show
    @exception = env['action_dispatch.exception']
    @status_code = ActionDispatch::ExceptionWrapper.new(env, @exception).status_code

    respond_to do |format|
      format.html {
        render file: "public/#{ @status_code }.html",
               status: @status_code
      }

      format.json {
        render json: { error: @exception.message, status: @status_code },
               status: @status_code
      }
    end
  end
end
