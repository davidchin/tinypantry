Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    resources :recipes, only: [:index, :show]
  end

  get '/*path', to: 'pages#index'
  root to: 'pages#index'
end
