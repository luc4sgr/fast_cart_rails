Rails.application.routes.draw do
  # Rotas públicas/autenticadas
  resources :users, only: [:index, :show, :create, :update, :destroy]
  resources :products, only: [:index, :show] # Apenas leitura para clientes
  resources :orders, only: [:index, :show, :create, :update, :destroy]

  post "/login", to: "auth#login"
  get "/me", to: "users#me"

  # Rotas administrativas
  namespace :admin do
    get "/dashboard", to: "dashboard#index"
    get "/logs", to: "logs#index"
    get "/stats", to: "stats#index"

    resources :users, only: [:index, :show, :create, :update, :destroy]
    resources :products, only: [:index, :show, :create, :update, :destroy]
    resources :orders, only: [:index, :show, :create, :update, :destroy]
  end
end
