json.array!(@stretch_routes) do |stretch_route|
  json.extract! stretch_route, :id, :stretch_source_id, :streatch_target_id, :tax_rate, :non_tax_rate, :secure_rate, :secure_rate_filch, :secure_rate_aggravated, :travel_time, :distance, :cost_kg, :tax_iss
  json.url stretch_route_url(stretch_route, format: :json)
end
