Rails.application.routes.draw do
  devise_for :users
  root "application#index"
  get "/about", to: "application#about", as: "about"
  resources :posts
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
