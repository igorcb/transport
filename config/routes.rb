Transport::Application.routes.draw do
  
  resources :specialties

  resources :links

  resources :owners

  resources :carriers

  resources :employees

  resources :vehicles

  resources :drivers

  resources :suppliers

  resources :clients
  
  root 'links#index'

end
