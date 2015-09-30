class IndexController < ApplicationController
  def index
    render json: '{"status": "You\'re riding Rails Messaging RESTful API!"}'
  end
end