Rails.application.routes.draw do
  resources :users, only: [ :index, :show, :create, :update, :destroy ]
  resources :products, only: [ :index, :show, :create, :update, :destroy ]
  resources :orders, only: [ :index, :show, :create, :update, :destroy ]

  post "/login", to: "auth#login"
  get "/me", to: "users#me"

  namespace :admin do
    get "/dashboard", to: "dashboard#index"

    resources :users, only: [ :index, :show, :create, :update, :destroy ]
    resources :products, only: [ :index, :show, :create, :update, :destroy ]
    resources :orders, only: [ :index, :show, :create, :update, :destroy ]
  end

  namespace :admin do
    get "/logs", to: "logs#index"
    get "/stats", to: "stats#index"
  end
end
