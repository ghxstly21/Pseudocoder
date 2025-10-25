Rails.application.routes.draw do
  root "sessions#new"

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: [ :new, :create ]

  get "/dashboard", to: "dashboard#index"
  get "/home", to: "pages#home", as: "home"
end
