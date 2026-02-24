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

  get "/forgot_password", to: "password_resets#new", as: "forgot_password"
  post "/forgot_password", to: "password_resets#create"
  get "/reset_password/:token", to: "password_resets#edit", as: "reset_password"
  patch "/reset_password/:token", to: "password_resets#update"

  post "/change_email", to: "email_changes#create", as: "change_email"
  get "/confirm_email/:token", to: "email_changes#confirm", as: "confirm_email_change"

  get "/home", to: "pages#home", as: "home"
  get "/aboutus", to: "pages#aboutus", as: "aboutus"
  get "/contactus", to: "pages#contactus", as: "contact"
  post "contact_submit", to: "pages#contact_submit"
  get "services", to: "pages#services"
  get "/affiliate", to: "pages#affiliateprogram"
  get "/faq", to: "pages#faq"
  get "/status", to: "pages#status"
  get "/feedback", to: "pages#feedback"
  get "/docs", to: "pages#documentation"
  get "/frontend", to: "pages#frontend", as: "frontened_presentation"
  get "/backend", to: "pages#backend", as: "backedn_presentation"
end
