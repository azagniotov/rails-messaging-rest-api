class API::V1::UsersController < API::V1::BaseApiController

  skip_before_action :api_key_authorize!, only: [:create]

  api :POST, 'api/v1/users', 'Creates a new user'
  param :user, Hash, :desc => 'New user information', :required => true do
    param :name, String, :desc => 'New user name', :required => true
    param :email, String, :desc => 'New user email', :required => true
    param :password, String, :desc => 'Desired user password', :required => true
  end
  def create
    # Param white listing
    user_params = params.require(:user).permit(:email, :password, :name)
    user = User.new(user_params)
    if user.save
      render json: user, status: 201
    end
  end

  api :GET, 'api/v1/users', 'Gets all users'
  def index
    render json: User.all
  end

  api :GET, 'api/v1/users/:user_id', 'Gets user by id'
  param :user_id, :number, :desc => 'User id', :required => true
  def show
    render json: User.find(params[:user_id])
  end

end
