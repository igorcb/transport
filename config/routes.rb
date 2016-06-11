Transport::Application.routes.draw do
  resources :control_pallets

  get '/print_contract/:id', to: 'reports#print_contract', as: 'print_contract'
  get '/print_inventory/:id', to: 'reports#print_inventory', as: 'print_inventory'
  
  resources :inventories

  resources :cancellations, only: [:index, :show, :edit, :update]  do
    member do
      get 'confirmation'
    end
  end

  resources :cashes

  resources :cte_xmls, only: [:index, :new, :create]
  
  get "internal_comments/create"
  resources :occurrences
  resources :internal_comments, only: [:create]
  resources :comments, only: [:create]

  get "comments/create"
  #get "ordem_service_type_services/index"
  resources :ordem_service_type_services do
    collection do
      get 'search'
      get 'send_email'
    end
  end
  resources :current_accounts

  resources :cash_accounts
  
  match '/get_address_by_cep', :controller => 'address', :action => 'get_address_by_cep', via: [:get]
  match '/dashboard_visit', :controller => 'static_pages', :action => 'dashboard_visit', via: [:get, :post]
  match '/dashboard_agent', :controller => 'static_pages', :action => 'dashboard_agent', via: [:get, :post]
  #match "/type_account_select" => "account_payables#type_account_select", via: [:get]
  match "/type_account_select", :controller => "account_payables", :action => 'type_account_select', via: [:get]
  #match "/sub_centro_custo_by_custo" => "account_payables#sub_centro_custo_by_custo", via: [:get]
  match "/sub_centro_custo_by_custo", :controller => "account_payables", :action => "sub_centro_custo_by_custo", via: [:get]
  match "/account_payables_search" => "account_payables#search", via: [:get]
  match "/lower_payables" => "account_payables#lower_payables", via: [:get]
  match "lower_all" => "account_payables#lower_all", via: [:post]

  match '/search', :controller => 'ordem_services', :action => 'search', via: [:get, :post]
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
  resources :lower_receivables, only: [:destroy]

  resources :account_receivables do 
    member do
      get 'lower'
      post 'pay'
    end    
  end

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

  # resources :teste, only: [:index] do
  #   collection do  
  #     get  "route_name/:param_a" => "controller#action_a"
  #     get  "route_name/:param_a/:param_b" => "controller#action_b"
  #     get  "route_name/:param_a/:param_b/:param_c/" => "controller#action_c"          
  #     get  "route_name/:param_a/:param_b/:param_c/:param_d" => "controller#action_d"
  #   end
  # end  

  resources :billings
  #match '/employees/get_employee_by_id', :controller => 'employees', :action => 'get_employee_by_id', via: [:get]
  match 'ordem_service_to_type_service/:id', :controller=>'ordem_services', :action => 'ordem_service_to_type_service', via: [:get, :post]
  match 'type_ordem_service/:type', :controller=>'ordem_services', :action => 'type_ordem_service', via: [:get, :post]
  match '/type_new_ordem_service', :controller => 'ordem_services', :action => 'type_new_ordem_service', via: [:get, :post]
  match '/calculate_freight', :controller => 'ordem_services', :action => 'calculate_freight', via: [:get, :post]
  match 'search_type_ordem_service/:type', :controller => 'ordem_services', :action => 'search_type_ordem_service', via: [:get, :post]
  #match "/search_logistic", :controller => "ordem_services", :action => "search_logistic", via: [:get, :post]
  match "/ordem_services_search_logistic" => "ordem_services#search_logistic", via: [:get]

  resources :ordem_services do
    resources :inventories
    member do
      get 'delivery'
      get 'close_os'  
      patch 'close'  
      get 'edit_agent'
      get 'show_agent'
      get 'pallet'
      get 'create_payables'
      post 'update_agent'
      get 'create_payables'
      get 'tag'
      get 'cancel'
      post 'update_cancel'
    end
    match 'search' => 'people#search', via: [:get, :post], as: :search
    
    collection do
      get "new_type/:id" => "ordem_services#new_type"
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
