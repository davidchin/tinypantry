Rails.application.routes.draw do
  scope 'api/v1' do
    devise_for :users,
      skip: :all,
      defaults: { format: :json },
      constraints: { format: :json }

    devise_scope :user do
      resources :sessions, only: [:create, :destroy], controller: 'api/v1/sessions'
      resources :users, only: [:index, :show]

      scope module: 'devise' do
        resources :passwords, only: [:create, :update]
        resources :registrations, only: [:create, :update, :destroy]
      end
    end
  end

  namespace :api, defaults: { format: :json }, constraints: { format: :json } do
    namespace :v1 do
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
