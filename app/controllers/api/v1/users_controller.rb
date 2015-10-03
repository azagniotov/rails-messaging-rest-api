class API::V1::UsersController < API::V1::BaseApiController

  skip_before_action :api_key_authorize!, only: [:create]

  def create
    user_params = raw_user_params
    user = User.new(user_params)
    if User.exists?(email: user.email)
      render :json => {
             code: 400,
             message: '400 Bad Request',
             description: "User with email '#{user.email}' is already registered"
         }, :status => 400
    else
      if user.save
        render json: user, serializer: UserSerializer, status: 201
      end
    end
  end

  def index
    render json: User.all, each_serializer: UserSerializer
  end

  def show
    render json: User.find(params[:user_id]), serializer: UserSerializer
  end

  def show_conversations
    render json: User.find(params[:user_id]), serializer: UserWithConversationsSerializer
  end

  private
  def raw_user_params
    params.require(:user).require(:email)
    params.require(:user).require(:password)
    params.require(:user).require(:name)
    params.require(:user).permit(:email, :password, :name)
  end

end
