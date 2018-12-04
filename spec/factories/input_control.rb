require_relative '../place_helper'

FactoryBot.define do
  factory :input_control do
    carrier
    driver
    place { PlaceHelper.faker_place }
    place_cart { place }
    place_cart_2 { place }
    place_horse { place }
    date_entry { Date.current }
    time_entry { Time.current }
    date_receipt { Date.current }
    palletized { false }
    quantity_pallets  { 1 }
    association :billing_client, factory: :client
    user
    # weight
    # volume
    # value_ton
    # value_kg
    # value_total
    # status
    # date_closing
    # observation
    # charge_discharge
    # shipment
    # container
    # team
    # dock
    # hangar
    # billing_client_id
    # client_table_price_id
    # stretch_route_id
    # type_service_id
    # place_confirmed
    # start_time_discharge
    # finish_time_discharge
    # started_user_id
    # received_user_id
    # date_scheduled
    # time_scheduled
    # motive_scheduled

  end
end
