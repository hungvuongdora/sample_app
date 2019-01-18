Rails.application.routes.draw do
  resources :users
  root "pages#home"
  get "/home", to: "pages#home"
  get "/help", to: "pages#help"
  get "/login", to: "users#new"
end
