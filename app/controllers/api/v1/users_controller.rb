class API::V1::UsersController < API::V1::BaseApiController

  skip_before_action :api_key_authenticate!, only: [:index, :create, :show, :update]

  def index
    render json: User.all
  end

  def create
    user_params = params.require(:user).permit(:email, :password, :name)
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id
      render json: user
    end
  end

  def show
    render json: User.find(params[:user_id])
  end

end
