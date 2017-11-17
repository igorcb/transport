json.array!(@config_systems) do |config_system|
  json.extract! config_system, :id, :config_key, :config_value, :config_description
  json.url config_system_url(config_system, format: :json)
end
