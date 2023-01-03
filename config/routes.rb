Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ('/')
  post root 'application#homepage'

  post '/auth/login', to: 'auth#login'
  post '/auth/register', to: 'auth#register'

  resources :users, only: :index

end
