Rails.application.routes.draw do
  resources :users, only: [:index, :show, :create, :update, :destroy]
  resources :products, only: [:index, :show, :create, :update, :destroy]
  resources :orders, only: [:index, :show, :create, :update, :destroy]
  post "/login", to: "auth#login"
  get "/me", to: "users#me"
  namespace :admin do
  get "/dashboard", to: "admin#dashboard"

  

end
