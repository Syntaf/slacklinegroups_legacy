Rails.application.routes.draw do
  # map controller routes
  get 'group/:id', to: 'map#index'
  get 'map/clusters', to: 'map#clusters'

  # embedded controller routes
  get 'embed', to: 'embedded_map#index'
  get 'embed/clusters', to: 'embedded_map#clusters'
  get 'embed/group/:id', to: 'embedded_map#index'


  get 'develop', to: 'develop#index'

  # about controller routes
  get 'about', to: 'about#index'

  # groups controller routes
  post 'groups/new', to: 'groups#create'
  resources :groups

  # admin controller routes
  resources :admin
  post 'admin/approve', to: 'admin#approve'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'map#index'
end