class API::V1::UsersController < API::V1::BaseApiController

  skip_before_action :api_key_authenticate!, only: [:index, :create, :show, :update]

  def index
    render json: '{"status": "OK"}'
  end

  def create
    # code to create a new post based on the parameters that
    # were submitted with the form (and are now available in the
    # params hash)
  end

  def show
    render json: '{"user": "' + params[:user_id] + '"}'
  end

  def update
    # code to figure out which post we're trying to update, then
    # actually update the attributes of that post.  Once that's
    # done, redirect us to somewhere like the Show page for that
    # post
  end
end
