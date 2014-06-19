Rails.application.routes.draw do
  devise_for :users
  resources :recipes, only: [:index, :show]

  root to: 'recipes#index'
end
