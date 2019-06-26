require_relative '../place_helper'

FactoryBot.define do
  factory :file_edi_occurrence, class: 'FileEdi' do
    type_file {FileEdi::TypeFile::EDI_OCCURRENCE}
    date_file { Date.current }
    name_file { "#{Time.now}.txt" }
    content { Faker::Lorem.sentences(1) }
    date_boarding { Date.current }
    place { PlaceHelper.faker_place }
    weight {Faker::Number.decimal(2, 3)}
    volume {Faker::Number.number(5)}
    value_total {Faker::Number.decimal(2, 3)}
    qtde {Faker::Number.number(2)}
    shipper
    carrier
  end

  factory :file_edi_notfis, class: 'FileEdi' do
    type_file {FileEdi::TypeFile::EDI_NOTFIS}
    date_file { Date.current }
    name_file { "#{Time.now}.txt" }
    content { Faker::Lorem.sentences(1) }
    date_boarding { Date.current }
    place { PlaceHelper.faker_place }
    weight {Faker::Number.decimal(2, 3)}
    volume {Faker::Number.number(5)}
    value_total {Faker::Number.decimal(2, 3)}
    qtde {Faker::Number.number(2)}
    shipper
    carrier
  end
end
