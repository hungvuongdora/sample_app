Rails.application.routes.draw do
  get "/home", to: "pages#home"
  get "/help", to: "pages#help"
  root "pages#home"
end
