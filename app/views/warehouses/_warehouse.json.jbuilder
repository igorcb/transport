json.extract! warehouse, :id, :name, :address, :number, :district, :city, :state, :zip_code, :created_at, :updated_at
json.url warehouse_url(warehouse, format: :json)
