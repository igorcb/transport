json.array!(@nature_freights) do |nature_freight|
  json.extract! nature_freight, :id, :name
  json.url nature_freight_url(nature_freight, format: :json)
end
