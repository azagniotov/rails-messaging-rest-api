RailsMessagingRestApi::Application.routes.draw do

  apipie

  scope '/api', module: 'api' do
    scope '/v1', module: 'v1', defaults: {format: 'json'} do

      scope '/sessions' do
        get '/' => 'sessions#index'
      end

      scope '/users' do
        get '/' => 'users#index'
        post '/' => 'users#create'
        scope '/:user_id' do
          get '/' => 'users#show'
        end
      end

      scope '/conversations' do
        get '/' => 'conversations#index'
        post '/' => 'conversations#create'
        scope '/:conversation_id' do
          get '/' => 'conversations#show'
          scope '/messages' do
            get '/' => 'conversations#show_messages'
          end
          scope '/users' do
            get '/' => 'conversations#show_users'
          end
        end
      end

    end
  end

  root 'welcome#index'
end