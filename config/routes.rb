RailsMessagingRestApi::Application.routes.draw do

  scope '/api', module: 'api' do
    scope '/v1', module: 'v1', defaults: {format: 'json'} do

      scope '/sessions' do
        get '/' => 'sessions#index', as: 'get_authorization_token_using_basic_auth'
      end

      scope '/users' do
        get '/' => 'users#index', as: 'get_all_users'
        post '/' => 'users#create', as: 'create_new_user'
        scope '/:user_id' do
          get '/' => 'users#show', as: 'get_user_by_id'
          scope '/conversations' do
            get '/' => 'users#show_conversations', as: 'get_user_conversations_by_user_id'
          end
        end
      end

      scope '/conversations' do
        get '/' => 'conversations#index', as: 'get_all_conversations'
        post '/' => 'conversations#create', as: 'create_new_conversation'
        scope '/:conversation_id' do
          get '/' => 'conversations#show', as: 'get_conversation_by_id'
          scope '/messages' do
            get '/' => 'conversations#show_messages', as: 'get_conversation_messages_by_conversation_id'
            post '/' => 'conversations#post_message', as: 'post_new_message_to_conversation_by_conversation_id'
          end
          scope '/users' do
            get '/' => 'conversations#show_users', as: 'get_conversation_users_by_conversation_id'
            post '/' => 'conversations#add_user', as: 'add_new_user_to_conversation_by_conversation_id'
          end
        end
      end

      scope '/messages' do
        scope '/:message_id' do
          get '/' => 'messages#show', as: 'get_message_by_id'
        end
      end

    end
  end

  root 'root#get_all_endpoint_categories_supported_by_api'

  match '/400' => 'application#bad_request', via: :all
  match '/404' => 'application#not_found', via: :all
  match '/500' => 'application#internal_error', via: :all
end