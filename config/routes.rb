Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  get "up" => "rails/health#show", as: :rails_health_check

  resources :frames, only: [:create, :show, :destroy] do
    resources :circles, only: [:create], shallow: true
  end

  resources :circles, only: [:update, :destroy]

  get '/circles', to: 'circles#index'
end
