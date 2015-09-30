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
          not_authorized 'X-Api-Key header is not set'
        else
          not_authorized 'Api key is not valid' unless api_key_valid
        end
      end

      def not_authorized(message)
        render json: {status: message}, status: 401
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

