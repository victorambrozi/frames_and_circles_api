Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  resources :frames, only: [:create, :show, :destroy] do
    resources :circles, only: [:create], shallow: true
  end

  resources :circles, only: [:update, :destroy]

  get '/circles', to: 'circles#index', as: :search_circles
end
