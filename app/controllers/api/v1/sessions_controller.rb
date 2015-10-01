class API::V1::SessionsController < API::V1::BaseApiController

  skip_before_action :api_key_authorize!, only: [:index]

  api :GET, 'api/v1/sessions', 'Gets API authentication token. Must set Basic Authorization header using email and password'
  def index
    authenticate
  end

  private
  def authenticate
    case request.format
      when Mime::JSON
        if (auth_token = authenticate_with_http_basic { |email, password| User.authenticate(email, password) })
          render json: auth_token
        else
          request_http_basic_authentication
        end
    end
  end
end
