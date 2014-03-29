Transport::Application.routes.draw do
  resources :carriers

  resources :employees

  resources :vehicles

  resources :drivers

  resources :suppliers

  resources :clients
  root 'clients#index'
end
