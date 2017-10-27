json.array!(@offer_drivers) do |offer_driver|
  json.extract! offer_driver, :id, :offer_charge_id, :date_incoming, :time_incoming, :driver, :type_vehicle, :place_horse, :place_cart_first, :place_cart_second, :status
  json.url offer_driver_url(offer_driver, format: :json)
end
