Rails.application.routes.draw do
  root "pages#home"
 resources :compilations, only: [ :create, :destroy ]

  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  post "/logout", to: "sessions#destroy"
  get "/guest_login", to: "sessions#guest_login"
  post "/guest_login", to: "sessions#guest_login"
  get "/signup", to: "users#new", as: "signup"

  resources :users, only: [ :new, :create, :edit, :update ]

  get "/home", to: "pages#home", as: "home"
  get "/aboutus", to: "pages#aboutus", as: "aboutus"
  get "/contactus", to: "pages#contactus", as: "contact"
  post "contact_submit", to: "pages#contact_submit"
  get "services", to: "pages#services"
end
