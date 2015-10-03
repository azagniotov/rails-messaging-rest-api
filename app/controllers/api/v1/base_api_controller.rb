module API
  module V1
    class BaseApiController < ApplicationController
      protect_from_forgery with: :null_session
      before_action :api_key_authorize!
      before_action only: [:index, :create, :show, :update]
      respond_to :json

      rescue_from ActionController::ParameterMissing do |exception|
        render :json => {
             code: 422,
             message: '422 Unprocessable Entity',
             description: "The server was unable to process the Request payload: '#{exception.param}' is missing"
         }, :status => 422
      end

      rescue_from ActionController::UnpermittedParameters do |exception|
        render :json => {
             code: 422,
             message: '422 Unprocessable Entity',
             description: "The server was unable to process the Request payload: #{exception}"
         }, :status => 422
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

