Rails.application.routes.draw do
  scope ':category' do
    resources :recipes, only: [:index, :show]
  end
end
