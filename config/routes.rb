Rails.application.routes.draw do
  api_route_options = {
    defaults: { format: :json },
    constraints: { format: :json },
    except: [:new, :edit]
  }

  scope 'api/v1', api_route_options do
    devise_for :users, skip: :all

    devise_scope :user do
      scope module: 'api/v1' do
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
    namespace :v1 do
      resources :recipes do
        get :related, on: :member
        get :search, on: :collection
      end

      resources :categories

      resources :feeds

      resources :users, only: [:show, :index]
    end
  end

  get '/*path', to: 'pages#app'

  root to: 'pages#app'
end
