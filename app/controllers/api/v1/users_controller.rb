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

  def update
    # code to figure out which post we're trying to update, then
    # actually update the attributes of that post.  Once that's
    # done, redirect us to somewhere like the Show page for that
    # post
  end

end
