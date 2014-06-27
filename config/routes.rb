Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_for :users

      resources :recipes, only: [:index, :show] do
        get :related, on: :member
        get :search, on: :collection
      end

      resources :categories, only: [:index, :show]

      resources :feeds, only: [:index, :show]

      resources :users, only: [:index, :show]
    end
  end

  get '/*path', to: 'pages#app'
  root to: 'pages#app'
end
