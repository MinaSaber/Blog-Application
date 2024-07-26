Rails.application.routes.draw do
  resources :users, only: [ :create, :show, :index, :destroy ]
  resources :posts, only: [ :create ]

  get "/me", to: "users#me"
  post "/auth/login", to: "auth#login"
end
