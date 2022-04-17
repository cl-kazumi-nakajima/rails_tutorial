Rails.application.routes.draw do
  root 'application#hello'
  resources :books
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  get 'status' => 'status#index', defaults: { format: 'json' }
end
