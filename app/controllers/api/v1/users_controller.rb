class Api::V1::UsersController < Api::V1::ApiController
  def index
    @users = User.all.page(params[:page])

    respond_with(@users)
  end

  def show
    @user = User.find(params[:id])

    respond_with(@user)
  end
end
