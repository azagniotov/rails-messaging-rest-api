class RootController < ApplicationController
  def get_all_endpoint_categories_supported_by_api
    discoverable_apis = Array.new
    Rails.application.routes.routes.map do |route|
      if route.path.spec.to_s.starts_with?('/api')
        path = route.path.spec.to_s.gsub(/\(\.:format\)/, '')#.gsub(/:[a-zA-Z_]+/, '1')
        method = %W{ GET POST PUT PATCH DELETE }.grep(route.verb).first.to_sym
        discoverable_apis << { name: route.name, endpoint: { method: method, path: path }}
      end
    end
    render json: JSON.pretty_generate(discoverable_apis)
  end
end