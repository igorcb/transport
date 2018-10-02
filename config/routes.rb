Transport::Application.routes.draw do

  resources :brokers

  resources :insurers do
    resources :table_insurances
    resources :policie_insurances
  end

  resources :notfis, only: [:index, :show] do
    collection do
      get :search
    end
  end

  resources :file_edis, only: [:index, :show] do
  collection do
      get :search
      get :select
      post :upload
    end
  end

  resources :edi_occurrences, only: [:index] do
    collection do
      get :search
      get :generate_file
    end
  end

  resources :clients_pallets

  match "/table_freights/get_calc_freight_minimum", :controller => "table_freights", :action => "get_calc_freight_minimum", via: [:get] 
  match '/calculate_liquidity', :controller => 'static_pages', :action => 'calculate_liquidity', via: [:get, :post]
  match "/stretch_routes/get_stretch_route_by_id", :controller => "stretch_routes", :action => "get_stretch_route_by_id", via: [:get] 
  match "/stretch_routes/get_stretch_route_by_state", :controller => "stretch_routes", :action => "get_stretch_route_by_state", via: [:get] 
  match "/stretch_routes/get_stretch_route_by_state_source_ant_target", :controller => "stretch_routes", :action => "get_stretch_route_by_state_source_ant_target", via: [:get] 

  resources :table_freights do
    collection do
      get :calculate_liquidity
    end
  end

  resources :table_icms do
    collection do
      get :search
    end
  end
  
  resources :antts_vehicles

  resources :antts do
    resources :antts_vehicles
  end

  resources :micro_regions do
    resources :micro_regions_cities
  end

  resources :meetings do
    resources :subjects do
      resources :subject_answers
    end
  end

  resources :action_inspectors, only: [:index, :edit, :update]

  resources :advance_moneys

  match "/get_stretch_routes_from_client_cnpj", :controller => "stretch_routes", :action => "get_stretch_routes_from_client_cnpj", via: [:get] 
  match "/get_client_table_price_of_by_client_cnpj_and_stretch_route", :controller => "client_table_prices", :action => "get_client_table_price_of_by_client_cnpj_and_stretch_route", via: [:get]
  match "/get_client_table_price_of_client", :controller => "client_table_prices", :action => "get_client_table_price_of_client", via: [:get]
  match "/get_client_table_price_of_client_service", :controller => "client_table_prices", :action => "get_client_table_price_of_client_service", via: [:get]

  resources :nature_freights

  resources :segments

  resources :promoters

  resources :stretch_routes

  resources :stretches
  
  resources :tasks do
    collection do
      get :search
    end
    member do
      get :start
      get :finish
    end    
  end

  match "list_input_scheduling" => "input_controls#list_input_scheduling",  via: [:get]
  match "list_ordem_service_scheduling" => "ordem_services#list_ordem_service_scheduling",  via: [:get]

  resources :companies, only: [:edit, :update, :show]

  resources :config_systems

  resources :client_representatives

  resources :representatives

  resources :offer_drivers do
    member do
      get :confirmed
      get :reject_form
      patch :reject
      get :noshow
      get :nonsuit
      get :reject_observation
    end    
  end

  resources :offer_charges do
    collection do
      get :search
    end
  end

  resources :breakdowns

  resources :schedulings do
    collection do
      get :search
    end
  end

  #match :stock_equipaments, :as => :stock_equipaments,  via: [:get]
  match :stock_equipaments,  to: 'stock_equipaments#index',  via: [:get]

  resources :transfer_equipaments, only: [:new] do
    collection do
      post :create
    end
  end
  
  resources :control_pallet_internals do
    member do
      get :term_pallet
    end
  end

  resources :direct_charges do
    member do
      get :finish_typing
      get :select_nfe
      post :create_ordem_service
    end
  end

  resources :input_controls do
    resources :breakdowns
    resources :breakdown_input_controls do
      get :product
      post :update_product, on: :collection    
    end
    member do
      get 'select_nfe'
      get 'select_pallets'
      post 'create_ordem_service'
      post 'create_stok_pallets'
      get 'finish_typing'
      get 'quitter'
      get :comments
      get :question
      get :printing
      get :print_blind
      get :tag
      get :start
      patch :update_start
      get :received
      patch :confirm_received
      get :reschedule
      patch :update_reschedule
    end
    collection do
      get :search
      get :oper
    end
    
    get :received_weight, on: :collection 
    get :received_weight_search, on: :collection 
  end

  #match '/select_xml_nfe_new_ordem_services', :controller => 'new_ordem_services', :action => 'select_xml_nfe', via: [:get, :post]
  resources :new_creation_ordem_services do
    get :select_xml_nfe, on: :collection
    post :process_xml_nfe, on: :collection  
  end

  resources :boardings do
    resources :breakdown_boardings
    member do
      get :print
      get :comments
      get :request_pallet
      post :requisition
      get :letter_freight
      get :confirmed
      patch :update_confirmed
      get :start
      patch :update_start
      get :checkin
      patch :update_checkin
      get :detail
    end
    collection do
      get :search
      get :oper
    end
    resources :boarding_items do
      post :update_row_order, on: :collection    
    end
    #match :cancellation, :as => :cancellation, :via => [:get, :put]  
    get :selection_shipment_search, on: :collection
  end

  resources :boarding_items do
    post :update_row_order, on: :collection  
    match :update_status, :as => :update_status, :via => [:get, :put]  
  end

  resources :lower_payables, only: [:destroy]
  resources :lower_receivables, only: [:destroy] do
    get :quitter, on: :member
  end

  resources :account_receivables do 
    member do
      get 'lower'
      post 'pay'
    end    
    get :received_driver, on: :collection
    collection do
      get :search
      post :lower_all
    end
  end

  resources :account_payables do 
    member do
      get 'lower'
      post 'pay'
      get :send_mail
      #delete 'lower_payable/id'
    end    
    collection do
      get 'cost_centers'
      get :search
    end
  end

  get '/print_inventory/:id', to: 'reports#print_inventory', as: 'print_inventory'
  get '/print_contract/:id', to: 'reports#print_contract', as: 'print_contract'
  #get '/print_boarding/:id', to: 'reports#print_boarding', as: 'print_boarding'
  get '/print_billing/:id', to: 'reports#print_billing', as: 'print_billing'

  match 'selection_pallet' => "control_pallets#selection_pallet",  via: [:get]
  match 'selection_pallet' => "control_pallets#selection_pallet",  via: [:get]
  match 'generate_ordem_service' => "control_pallets#generate_ordem_service",  via: [:post]
  match 'request_payment/:id' => "ordem_services#request_payment", via: [:post]

  match 'selection_shipment' => "boardings#selection_shipment",  via: [:get]
  match 'generate_shipping' => "boardings#generate_shipping",  via: [:post]
  match 'search_ordem_service' => "boardings#search_ordem_service",  via: [:get]

  resources :sub_cost_center_threes

  resources :control_pallets do
    member do
      get :print
    end
  end
  
  resources :inventories

  resources :cancellations, only: [:index, :show, :edit, :update, :create]  do
    member do
      get 'confirmation'
    end
  end

  resources :cashes do
  end
  
  resources :nfe_xmls#, only: [:index, :edit, :update]
  resources :cte_xmls, only: [:index, :new, :create]

  resources :nfe_keys, only: [:index, :show, :edit, :update] do
    member do
      get :edit_action_inspector
      patch :update_action_inspector
      get :pending
      patch :update_pending
      get :request_receipt
      get :request_payment_dae
      get :take_dae
      patch :update_take_dae
    end
    collection do
      get :search
    end
  end
  
  get "internal_comments/create"
  resources :occurrences, only: [:index, :show]

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

  match "/get_city_by_uf", :controller => "address", :action => "get_city_by_uf", via: [:get]
  
  match '/dashboard_boarding', :controller => 'static_pages', :action => 'dashboard_boarding', via: [:get, :post]
  match '/get_address_by_cep', :controller => 'address', :action => 'get_address_by_cep', via: [:get]
  match '/dashboard_visit', :controller => 'static_pages', :action => 'dashboard_visit', via: [:get, :post]
  match '/dashboard_agent', :controller => 'static_pages', :action => 'dashboard_agent', via: [:get, :post]
  match '/dashboard_oper', :controller => 'static_pages', :action => 'dashboard_oper', via: [:get, :post]
  match '/dashboard_port', :controller => 'static_pages', :action => 'dashboard_port', via: [:get, :post]
  match '/dashboard_client', :controller => 'static_pages', :action => 'dashboard_client', via: [:get, :post]
  #match '/client_ordem_service/:id', :controller=>'ordem_services', :action => '', via: [:get, :post]
  match '/client_ordem_service/:id', to: 'ordem_services#ordem_service_comments', as: 'client_ordem_service', via: [:get]
  #match "/type_account_select" => "account_payables#type_account_select", via: [:get]
  match "/type_account_select", :controller => "account_payables", :action => 'type_account_select', via: [:get]
  #match "/sub_centro_custo_by_custo" => "account_payables#sub_centro_custo_by_custo", via: [:get]
  match "/sub_centro_custo_by_custo", :controller => "account_payables", :action => "sub_centro_custo_by_custo", via: [:get]
  match "/sub_centro_custo_three_by_custo", :controller => "account_payables", :action => "sub_centro_custo_three_by_custo", via: [:get]
  match "/get_product_by_nfe_xmls_and_product", :controller => "item_input_controls", :action => "get_product_by_nfe_xmls_and_product", via: [:get]
  match "/get_product_by_cod_prod", :controller => "products", :action => "get_product_by_cod_prod", via: [:get]
  match "/get_nfe_xmls", :controller => "item_input_controls", :action => "get_nfe_xmls", via: [:get]
  match "/get_nfe_keys_by_boarding", :controller => "nfe_keys", :action => "get_nfe_keys_by_boarding", via: [:get]
  match "/get_product_by_nfe_keys_and_boarding", :controller => "item_ordem_services", :action => "get_product_by_nfe_keys_and_boarding", via: [:get]
  #match "/account_payables_search" => "account_payables#search", via: [:get]
  match "/cashes_search" => "cashes#search", via: [:get]
  match "/schedulings_search" => "schedulings#search", via: [:get]
  match "/lower_payables" => "account_payables#lower_payables", via: [:get]
  match "lower_all" => "account_payables#lower_all", via: [:post]

  match '/search', :controller => 'ordem_services', :action => 'search', via: [:get, :post]
  match 'faturamento' => "ordem_services#faturamento",  via: [:get]
  match 'invoice' => "ordem_services#invoice",  via: [:post]
  match '/stocks', :controller => 'control_pallets', :action => 'estoque', via: [:get]
  match '/clients/get_client_by_cnpj', :controller => 'clients', :action => 'get_client_by_cnpj', via: [:get]
  match '/clients/get_client_by_id', :controller => 'clients', :action => 'get_client_by_id', via: [:get]
  match '/drivers/get_driver_by_id', :controller => 'drivers', :action => 'get_driver_by_id', via: [:get]
  match '/drivers/get_driver_by_cpf', :controller => 'drivers', :action => 'get_driver_by_cpf', via: [:get]
  match '/drivers/get_driver_by_cpf_exist', :controller => 'drivers', :action => 'get_driver_by_cpf_exist', via: [:get]
  match '/suppliers/get_supplier_by_id', :controller => 'suppliers', :action => 'get_supplier_by_id', via: [:get]
  match '/carriers/get_carrier_by_id', :controller => 'carriers', :action => 'get_carrier_by_id', via: [:get]
  match '/carriers/get_carrier_by_cnpj', :controller => 'carriers', :action => 'get_carrier_by_cnpj', via: [:get]
  match '/employees/get_employee_by_id', :controller => 'employees', :action => 'get_employee_by_id', via: [:get]
  match '/owners/get_owner_by_cpf_cnpj', :controller => 'owners', :action => 'get_owner_by_cpf_cnpj', via: [:get]
  match '/vehicles/get_vehicle_by_place', :controller => 'vehicles', :action => 'get_vehicle_by_place', via: [:get]
  match '/vehicles/get_vehicle_by_renavan', :controller => 'vehicles', :action => 'get_vehicle_by_renavan', via: [:get]


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
  #match '/employees/get_employee_by_id', :controller => 'employees', :action => 'get_employee_by_id', via: [:get]
  match 'ordem_service_to_type_service/:id', :controller=>'ordem_services', :action => 'ordem_service_to_type_service', via: [:get, :post]
  match 'type_ordem_service/:type', :controller=>'ordem_services', :action => 'type_ordem_service', via: [:get, :post]
  match '/type_new_ordem_service', :controller => 'ordem_services', :action => 'type_new_ordem_service', via: [:get, :post]
  match '/calculate_freight', :controller => 'ordem_services', :action => 'calculate_freight', via: [:get, :post]
  match 'search_type_ordem_service/:type', :controller => 'ordem_services', :action => 'search_type_ordem_service', via: [:get, :post]
  #match "/search_logistic", :controller => "ordem_services", :action => "search_logistic", via: [:get, :post]
  match "/ordem_services_search_logistic" => "ordem_services#search_logistic", via: [:get]

  resources :ordem_services do
    resources :nfs_keys do
      get :request_cancellation
    end
    resources :cte_keys do
      get :request_cancellation
    end
    resources :inventories
    member do
      #get 'delivery'
      get :delivery
      patch :update_delivery
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
      get 'left_handed'
      patch 'update_left_handed'
      #get 'request_cancelation_nfs'
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

  resources :products do
    collection do
      get :search
    end
  end

  resources :activities

  #resources :sessions#, only: [:new, :create, :destroy]

  devise_for :users
  resources :phone_calls

  resources :type_services

  resources :specialties

  resources :links do
    post :update_row_order, on: :collection    
  end

  resources :owners

  resources :carrier_credentials

  resources :employees do
    get :gallery
  end

  resources :vehicles do
    collection do
      get :search
    end
  end

  resources :drivers do
    collection do
      get :search
    end
  end

  resources :suppliers do
    collection do
      get :search
    end
  end

  resources :carriers do
    resources :client_table_prices
    
    resources :carrier_credentials
    collection do
      get :search
    end
  end

  resources :client_table_prices

  resources :clients do
    resources :clients_pallets
    resources :client_table_prices
    resources :client_discharges
    resources :client_requirements
    collection do
      get :search
    end
  end
  
  resource :user, only: [:edit] do
    collection do
      patch 'update_password'
    end
  end  
  #root 'links#index'
  root to: 'static_pages#home'

end
