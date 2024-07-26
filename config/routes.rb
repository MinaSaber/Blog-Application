require "sidekiq/web"

Rails.application.routes.draw do
  resources :users, only: [ :create ]
  resources :posts, only: [ :create, :index, :show, :update, :destroy ] do
    resources :comments, only: [ :create, :update, :destroy ]
  end

  get "/me", to: "users#me"
  post "/auth/login", to: "auth#login"

  mount Sidekiq::Web => "/sidekiq"
end
