Transport::Application.routes.draw do

  #get "ordem_service_type_services/index"
  resources :ordem_service_type_services do
    collection do
      get 'search'
      get 'send_email'
    end
  end
  resources :current_accounts

  resources :cash_accounts

  match '/dashboard_visit', :controller => 'static_pages', :action => 'dashboard_visit', via: [:get, :post]
  match '/dashboard_agent', :controller => 'static_pages', :action => 'dashboard_agent', via: [:get, :post]
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
  match '/clients/get_client_by_cnpj', :controller => 'clients', :action => 'get_client_by_cnpj', via: [:get]
  match '/clients/get_client_by_id', :controller => 'clients', :action => 'get_client_by_id', via: [:get]
  match '/drivers/get_driver_by_id', :controller => 'drivers', :action => 'get_driver_by_id', via: [:get]
  match '/suppliers/get_supplier_by_id', :controller => 'suppliers', :action => 'get_supplier_by_id', via: [:get]
  match '/carriers/get_carrier_by_id', :controller => 'carriers', :action => 'get_carrier_by_id', via: [:get]
  match '/employees/get_employee_by_id', :controller => 'employees', :action => 'get_employee_by_id', via: [:get]

  resources :lower_payables, only: [:destroy]

  resources :account_payables do 
    member do
      get 'lower'
      post 'pay'
      #delete 'lower_payable/id'
    end    
    collection do
      get 'cost_centers'
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
    member do
      get 'close_os'
      get 'edit_agent'
      get 'show_agent'
      get 'create_payables'
      post 'update_agent'
    end
    match 'search' => 'people#search', via: [:get, :post], as: :search
    collection do
      get 'index_agent'
      get 'request_payables'
      get 'billing_group_places'
    end
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
  #root 'links#index'
  root to: 'static_pages#home'

end
