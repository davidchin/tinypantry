require 'api/route_contraint'

Rails.application.routes.draw do
  api_route_options = {
    defaults: { format: :json },
    constraints: { format: :json },
    except: [:new, :edit]
  }

  scope :api, api_route_options do
    devise_for :users, skip: :all

    devise_scope :user do
      scope module: 'api/v1', constraints: Api::RouteContraint.new(version: 1, default: true) do
        post 'login', to: 'sessions#create'
        delete 'logout', to: 'sessions#destroy'
        get 'verify', to: 'sessions#verify'
      end

      scope module: 'devise' do
        resource :password, only: [:create, :update]
        resources :users, only: [:create, :update, :destroy],
                          controller: 'registrations'
      end
    end
  end

  namespace :api, api_route_options do
    scope module: :v1, constraints: Api::RouteContraint.new(version: 1, default: true) do
      resources :recipes do
        get :search, on: :collection

        member do
          get :related
          post :bookmark
        end
      end

      resources :categories

      resources :feeds

      resources :users, only: [:show, :index] do
        get :bookmarks, on: :member
      end
    end
  end

  get '/*path', to: 'pages#app'

  root to: 'pages#app'
end
