class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session

  rescue_from ActionController::ParameterMissing do |exception|
    render_error_as_json(422, 'Unprocessable Entity', "The server was unable to process the Request payload: '#{exception.param}' is missing")
  end

  rescue_from ActionController::UnpermittedParameters do |exception|
    render_error_as_json(422, 'Unprocessable Entity', "The server was unable to process the Request payload: #{exception}")
  end

  def bad_request
    render_error_as_json(400, 'Bad Request', 'The syntax of the request entity is incorrect')
  end

  def not_found
    render_error_as_json(404, 'Not Found', 'The server has not found anything matching the Request-URI')
  end

  def internal_error
    render_error_as_json(500, 'Internal Server Error', 'The server encountered an unexpected condition which prevented it from fulfilling the request')
  end

  private
  def render_error_as_json(code, message, description)
    render :json => {
               code: code,
               message: "#{code} #{message}",
               description: description
           }, :status => code
  end
end
