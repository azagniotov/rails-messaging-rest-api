class ErrorsController < ApplicationController

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

  def unprocessable
    render :json => {
               code: 422,
               message: '422 Unprocessable Entity',
               description: 'The server was unable to process the contained instructions'
           }, :status => 422
  end

  def internal_error
    render :json => {
              code: 500,
              message: '500 Internal Server Error',
              description: 'The server encountered an unexpected condition which prevented it from fulfilling the request'
            }, :status => 500
  end
end