Rails.application.routes.draw do
  root "home#index"

  get "/login", to: "home#index"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: [ :new, :create ]

  get "/home", to: "pages#home", as: "home"
  get "/aboutus", to: "pages#aboutus", as: "aboutus"
  get "/contactus", to: "pages#contactus", as: "contact"
  get "contactus", to: "pages#contactus"
  post "contact_submit", to: "pages#contact_submit"
  get "services", to: "pages#services"
  post "guest_login", to: "sessions#guest_login", as: :guest_session
end
