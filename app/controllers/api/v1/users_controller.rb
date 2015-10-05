class API::V1::UsersController < API::V1::BaseApiController

  skip_before_action :api_key_authorize!, only: [:create]

  def create
    user = User.new(raw_user_params)
    if User.exists?(email: user.email)
      render_error_as_json(409, 'Conflict', "User with email '#{user.email}' is already registered")
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
