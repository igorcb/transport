require_relative '../place_helper'

FactoryBot.define do
  factory :vehicle do
     tipo     { Vehicle::Tipo::TRACAO }
     tipo_veiculo { Vehicle::TipoVeiculo::CARRETA_LS}
     tipo_carroceria { Vehicle::TipoCarroceria::BAU }
     marca { Faker::Vehicle.make }
     modelo { Faker::Vehicle.model }
     ano { Faker::Vehicle.year }
     cor { Faker::Vehicle.color }
     municipio_emplacamento { Faker::Address.city }
     estado { Faker::Address.state_abbr }
     renavan { PlaceHelper.faker_renavan }
     chassi { PlaceHelper.faker_chassi }
     placa { PlaceHelper.faker_place }
     capacity { 30000}
     especie { 'teste' }
     numero_eixos { 5 }
     numero_loks { 2 }
     qtde_paletes { 30 }

     grade { false }
     cordas { false }
     lonas { false }
     capacitacao { true }
     kit_quimico { true }
  end

  factory :vehicle_tracao, class: 'Vehicle' do
     tipo     { Vehicle::Tipo::TRACAO }
     tipo_veiculo { Vehicle::TipoVeiculo::CARRETA_LS}
     tipo_carroceria { Vehicle::TipoCarroceria::BAU }
     marca { Faker::Vehicle.make }
     modelo { Faker::Vehicle.model }
     ano { Faker::Vehicle.year }
     cor { Faker::Vehicle.color }
     municipio_emplacamento { Faker::Address.city }
     estado { Faker::Address.state_abbr }
     renavan { PlaceHelper.faker_renavan }
     chassi { PlaceHelper.faker_chassi }
     placa { PlaceHelper.faker_place }
     capacity { 30000}
     especie { 'teste' }
     numero_eixos { 5 }
     numero_loks { 2 }
     qtde_paletes { 30 }

     grade { false }
     cordas { false }
     lonas { false }
     capacitacao { true }
     kit_quimico { true }
  end

  factory :vehicle_reboque, class: 'Vehicle' do
     tipo     { Vehicle::Tipo::REBOQUE }
     tipo_veiculo { Vehicle::TipoVeiculo::CARRETA_LS}
     tipo_carroceria { Vehicle::TipoCarroceria::BAU }
     marca { Faker::Vehicle.make }
     modelo { Faker::Vehicle.model }
     ano { Faker::Vehicle.year }
     cor { Faker::Vehicle.color }
     municipio_emplacamento { Faker::Address.city }
     estado { Faker::Address.state_abbr }
     renavan { PlaceHelper.faker_renavan }
     chassi { PlaceHelper.faker_chassi }
     placa { PlaceHelper.faker_place }
     capacity { 30000}
     especie { 'teste' }
     numero_eixos { 5 }
     numero_loks { 2 }
     qtde_paletes { 30 }

     grade { false }
     cordas { false }
     lonas { false }
     capacitacao { true }
     kit_quimico { true }
  end

  factory :vehicle_tracao_bau, class: 'Vehicle' do
     tipo     { Vehicle::Tipo::TRACAO_BAU }
     tipo_veiculo { Vehicle::TipoVeiculo::CARRETA_LS}
     tipo_carroceria { Vehicle::TipoCarroceria::BAU }
     marca { Faker::Vehicle.make }
     modelo { Faker::Vehicle.model }
     ano { Faker::Vehicle.year }
     cor { Faker::Vehicle.color }
     municipio_emplacamento { Faker::Address.city }
     estado { Faker::Address.state_abbr }
     renavan { PlaceHelper.faker_renavan }
     chassi { PlaceHelper.faker_chassi }
     placa { PlaceHelper.faker_place }
     capacity { 30000}
     especie { 'teste' }
     numero_eixos { 5 }
     numero_loks { 2 }
     qtde_paletes { 30 }

     grade { false }
     cordas { false }
     lonas { false }
     capacitacao { true }
     kit_quimico { true }
  end
end
