module API
  module V1
    class BaseApiController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :api_key_authorize!
      before_action only: [:index, :create, :show, :update]
      respond_to :json

      private
      def api_key_authorize!
        if !authorization_header
          render_error_as_json 401, 'Unauthorized', 'X-Api-Key header is not set'
        else
          render_error_as_json 401, 'Unauthorized', 'Api key is not valid' unless api_key_valid
        end
      end

      def authorization_header
        request.headers['X-Api-Key']
      end

      def api_key_valid
        User.find_by(auth_token: request.headers['X-Api-Key'])
      end
    end
  end
end

