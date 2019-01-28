Rails.application.routes.draw do
  root "pages#home"
  get "/home", to: "pages#home"
  get "/help", to: "pages#help"
  get "/signup", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"
  resources :users
  resources :account_activations, only: %i(edit)
end
