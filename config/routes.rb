Rails.application.routes.draw do
  get 'home/index'
  get 'graphs', to: 'home#graphs'
  resources :expenses
  root 'expenses#index'
  resources :categories
  resources :users
  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]
end
