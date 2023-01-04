Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
  # Defines the root path route ('/')

  post root 'application#homepage'
  post '/auth/login', to: 'auth#login'
  post '/auth/register', to: 'auth#register'

  resources :users, only: :index

  resources :friendships, only: [:index, :show, :create, :update]
  delete '/friendships/:id/reject', to: 'friendships#reject'
  delete '/friendships/:id/remove', to: 'friendships#remove'

  get '/messages/list-conversations', to: 'messages#list_conversations'
  get '/messages/:id', to: 'messages#show'
  post '/messages/', to: 'messages#create'
  patch '/messages/:id_message/mark', to: 'messages#mark_as_read'
end
