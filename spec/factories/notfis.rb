require_relative '../place_helper'

FactoryBot.define do
  factory :notfis, class: 'Notfis' do
    place { PlaceHelper.faker_place }
    date_notfis { Date.current }
    client
    file_edi
  end
end
