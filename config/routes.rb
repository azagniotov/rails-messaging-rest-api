RailsMessagingRestApi::Application.routes.draw do

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
          scope '/conversations' do
            get '/' => 'users#show_conversations'
          end
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

  match '/400' => 'errors#bad_request', via: :all
  match '/404' => 'errors#not_found', via: :all
  match '/500' => 'errors#internal_error', via: :all
end