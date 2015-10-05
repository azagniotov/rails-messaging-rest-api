class RootController < ApplicationController
  def get_all_endpoint_categories_supported_by_api
    discoverable_apis = Array.new
    Rails.application.routes.routes.map do |route|
      if route.path.spec.to_s.starts_with?('/api')
        discoverable_apis << { name: route.name, endpoint: endpoint(route) }
      end
    end
    render json: JSON.pretty_generate(discoverable_apis)
  end

  private
  def endpoint(route)
    path = route.path.spec.to_s.gsub(/\(\.:format\)/, '')
    method = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first.to_sym
    path_param = route.path.spec.to_s.gsub(/\(\.:format\)/, '').match(/:[a-zA-Z_]+/)
    if path_param.nil?
      { method: method, path: path }
    else
      { method: method, path: path, path_param: path_param.to_s.gsub(/:+/, '') }
    end
  end
end