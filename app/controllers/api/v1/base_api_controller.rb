module API
  module V1
    class BaseApiController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :api_key_authorize!
      before_action only: [:index, :create, :show, :update]
      respond_to :json

      protected
      def render_error_as_json(code, message, description)
        render :json => {
               code: code,
               message: "#{code} #{message}",
               description: description
           }, :status => code
      end

      private
      def api_key_authorize!
        if !authorization_header
          forbidden 'X-Api-Key header is not set'
        else
          forbidden 'Api key is not valid' unless api_key_valid
        end
      end

      def forbidden(message)
        render :json => {
                   code: 403,
                   message: '403 Forbidden',
                   description: message
               }, :status => 403
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

