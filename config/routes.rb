# Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
Rails.application.routes.draw do
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  get 'users/new'
  root 'static_pages#home'
  get '/help', to: 'static_pages#help'
  get '/about', to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/signup', to: 'users#new'
  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  delete '/logout', to: 'sessions#destroy'

  # /users/1/following や /users/1/followers のようになる
  resources :users do
    # memberメソッドを使うとユーザーidが含まれているURLを扱うようになる
    member do
      get :following, :followers
    end

    # idを指定せずにすべてのメンバーを表示するには、次のようにcollectionメソッドを使う
    # このコードは /users/tigers というURLに応答
    # collection do
    #  get :tigers
    # end
  end

  resources :account_activations, only: [:edit]
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :microposts, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  resources :books

  # Defines the root path route ("/")
  # root "articles#index"
  get 'status' => 'status#index', defaults: { format: 'json' }
end
