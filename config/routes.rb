Rails.application.routes.draw do
  devise_for :users

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :recipes, only: [:index, :show] do
        get :related, on: :member
        get :search, on: :collection
      end

      resources :categories, only: [:index, :show]

      resources :feeds, only: [:index, :show]

      resources :users, only: :show
    end
  end

  get '/*path', to: 'pages#app'
  root to: 'pages#app'
end
