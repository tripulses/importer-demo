Rails.application.routes.draw do
  get 'home/index'

  get '/people/search' => 'people#search'
  resources :people, only: %i[index show]
  
  root 'home#index'
end
