module Api
  module V1
    class BaseApiController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :api_key_authenticate!
      before_action only: [:index, :create, :show, :update]
      respond_to :json

      private
      def api_key_authenticate!
        not_authorized 'X-Api-Key header is not set' unless authorization_header
        not_authorized 'Api key is not valid' unless api_key_valid
      end

      def not_authorized(message)
        render json: {status: message}, status: 401
      end

      def authorization_header
        request.headers['X-Api-Key']
      end

      def api_key_valid
        true
      end

    end
  end
end

