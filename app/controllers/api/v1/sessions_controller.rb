class API::V1::SessionsController < API::V1::BaseApiController

  skip_before_action :api_key_authorize!, only: [:index]

  def index
    authenticate
  end

  private
  def authenticate
    case request.format
      when Mime::JSON
        if (auth_token = authenticate_with_http_basic { |email, password|
          @email = email
          User.authenticate(email, password)
        })
          render json: { email: @email, auth_token: auth_token }
        else
          request_http_basic_authentication
        end
    end
  end
end
