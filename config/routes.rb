Rails.application.routes.draw do
  get 'map/index'
  get 'map/groups'
  get 'map/pointclouds'
  get 'map/cover'
  get 'map/autocomplete'
  get 'about', to: 'about#index'
  resources :groups
  resources :admin

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'map#index'
end
