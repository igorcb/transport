Transport::Application.routes.draw do

  match '/dashboard', :controller => 'static_pages', :action => 'dashboard', via: [:get, :post]
  match "type_account_select" => "account_payables#type_account_select", via: [:get]
  match "/sub_centro_custo_by_custo" => "account_payables#sub_centro_custo_by_custo", via: [:get]
  match "/account_payables_search" => "account_payables#search", via: [:get]
  match "/lower_payables" => "account_payables#lower_payables", via: [:get]
  match "lower_all" => "account_payables#lower_all", via: [:post]

  match '/search', :controller => 'ordem_services', :action => 'search', via: [:get, :post]
  match 'ordem_service_to_type_service/:id', :controller=>'ordem_services', :action => 'ordem_service_to_type_service', via: [:get, :post]
  match 'faturamento' => "ordem_services#faturamento",  via: [:get]
  match 'invoice' => "ordem_services#invoice",  via: [:post]
  match '/stocks', :controller => 'pallets', :action => 'estoque', via: [:get]
  match '/pallets/get_client_by_cnpj', :controller => 'pallets', :action => 'get_client_by_cnpj', via: [:get]

  resources :account_payables do 
    member do
      get 'lower'
      post 'pay'
    end    
  end

  resources :payment_methods

  resources :sub_cost_centers

  resources :cost_centers

  resources :historics

  resources :pallets do
    collection do
      get 'visit_all'
      get 'visit_complete'
      get 'visit_open'
    end
    member do
      get 'driver_select'
      post 'create_os'
    end
  end
  
  resources :billings

  resources :ordem_services do
    get 'close_os' , on: :member
    match 'search' => 'people#search', via: [:get, :post], as: :search
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
  
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end  
  root 'links#index'

end
