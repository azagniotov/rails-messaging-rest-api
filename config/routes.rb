RailsMessagingRestApi::Application.routes.draw do
  namespace :api, defaults: {format: 'json'} do
    namespace :v1 do
      resources :users, :param => :user_id, only: [:create, :show]
      resources :sessions, only: [:index]
    end
  end

  root 'welcome#index'
end