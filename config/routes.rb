RailsMessagingRestApi::Application.routes.draw do
  scope '/api', module: 'api' do
    scope '/v1', module: 'v1', defaults: {format: 'json'} do

      # Users
      scope '/users' do
        get '/' => 'users#index'
        post '/' => 'users#create'
        scope '/:id' do
          get '/' => 'users#show'
          put '/' => 'users#update'
        end
      end

    end
  end

  root 'index#index'
end