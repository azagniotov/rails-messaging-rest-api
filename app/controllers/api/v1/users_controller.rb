class API::V1::UsersController < API::V1::BaseApiController

  skip_before_action :api_key_authorize!, only: [:create]

  def create
    user_params = params.require(:user).permit(:email, :password, :name)
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    end
  end

  def show
    render json: User.find(params[:user_id])
  end

end
