class ErrorsController < ApplicationController
  protect_from_forgery with: :null_session

  def bad_request
    render :json => {
               code: 400,
               message: '400 Bad Request',
               description: 'The syntax of the request entity is incorrect'
           }, :status => 400
  end

  def not_found
    render :json => {
               code: 404,
               message: '404 Not Found',
               description: 'The server has not found anything matching the Request-URI'
           }, :status => 404
  end

  def internal_error
    render :json => {
              code: 500,
              message: '500 Internal Server Error',
              description: 'The server encountered an unexpected condition which prevented it from fulfilling the request'
            }, :status => 500
  end
end