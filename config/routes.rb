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
        
        resources :users, only: [:create, :update, :destroy],
                          controller: 'registrations'

        resource :password, only: [:create, :update]
      end
    end
  end

  namespace :api, api_route_options do
    scope module: :v1, constraints: Api::RouteContraint.new(version: 1, default: true) do
      resources :recipes do
        get :search, on: :collection
        get :related, on: :member
      end

      resources :categories

      resources :feeds

      resources :users, only: [:show, :index] do
        resources :bookmarks, only: [:index, :create, :destroy] do
          get :summary, on: :collection
        end

        resources :bookmarked_recipes, only: [:index], path: 'bookmarked-recipes' do
          get :search, on: :collection
        end
      end
    end
  end

  # Sitemap
  get 'sitemap.xml', to: 'sitemaps#show', defaults: { format: 'xml' }

  # Named paths
  get '/users/password/edit', to: 'pages#app', as: 'edit_password'

  resources :recipes, to: 'pages#app', only: [:index, :show] do
    collection do
      resources :category, to: 'pages#app', only: [:show]
    end
  end

  # Let SPA handle routing
  get '/*path', to: 'pages#app', constraints: { path: /(?!\bapi\b\/?).*/ }
  root to: 'pages#app'
end
