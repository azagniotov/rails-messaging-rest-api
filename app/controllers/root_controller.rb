class RootController < ApplicationController
  def get_all_endpoint_categories_supported_by_api
    @available_endpoints = Hash.new
    Rails.application.routes.routes.map do |route|
      if route.path.spec.to_s.starts_with?('/api')
        endpoint(route)
      end
    end
    render json: JSON.pretty_generate(@available_endpoints)
  end

  private
  def endpoint(route)
    spec = route.path.spec.to_s
    path = spec.gsub(/\(\.:format\)/, '')
    resource = path.split('/').first(4).last
    version = path.split('/').first(3).last.gsub(/[v]+/, '')

    if @available_endpoints[resource].nil?
      @available_endpoints[resource] = Array.new
    end

    method = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first.to_sym
    path_param = spec.gsub(/\(\.:format\)/, '').match(/:[a-zA-Z_]+/)
    if path_param.nil?
      @available_endpoints[resource] << { version: version, name: route.name, method: method, path: path }
    else
      @available_endpoints[resource] << { version: version, name: route.name, method: method, path: path, path_param: path_param.to_s.gsub(/:+/, '') }
    end
  end
end
