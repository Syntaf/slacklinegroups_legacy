Rails.application.routes.draw do
  get 'group/:id', to: 'map#index'
  get 'map/index'
  get 'map/clusters', to: 'map#getclusters'
  get 'map/cover'
  get 'about', to: 'about#index'

  
  post 'groups/new', to: 'groups#create'
  resources :groups
  resources :admin
  post 'admin/approve', to: 'admin#approve'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'map#index'
end