Transport::Application.routes.draw do
  match 'faturamento' => "ordem_services#faturamento",  via: [:get]
  match 'billing' => "ordem_services#billing",  via: [:post]
  
  resources :ordem_services do
    get 'close_os' , on: :member
  end

  resources :group_clients

  resources :operatings

  match "/nome_banco" => "drivers#nome_banco",  via: [:get]
  resources :budgets

  resources :categories

  #resources :cubages

  resources :products

  resources :activities

  #resources :sessions#, only: [:new, :create, :destroy]

  devise_for :users
  resources :phone_calls

  resources :type_services

  resources :specialties

  resources :links

  resources :owners

  resources :carriers

  resources :employees do
    get 'gallery'
  end

  resources :vehicles

  resources :drivers

  resources :suppliers

  resources :clients
  
  root 'links#index'

end
