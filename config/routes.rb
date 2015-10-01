RailsMessagingRestApi::Application.routes.draw do
  scope '/api', module: 'api' do
    scope '/v1', module: 'v1', defaults: {format: 'json'} do

      scope '/users' do
        post '/' => 'users#create'
        scope '/:user_id' do
          get '/' => 'users#show'
        end
      end

      scope '/sessions' do
        get '/' => 'sessions#index'
      end

    end
  end

  root 'welcome#index'
end