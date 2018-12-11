FactoryBot.define do
  factory :company do
    razao_social { Faker::Name.name }
    cnpj { Faker::CNPJ.cnpj  }
    inscricao_estadual  { '000000' }
    inscricao_municipal  { '000000' }
    endereco {Faker::Address.street_name}
    numero { Faker::Address.building_number }
    complemento {"COMPLEMENTO"}
    bairro { Faker::Lorem.word }
    cidade { Faker::Address.city }
    estado { Faker::Address.state_abbr }
    cep { Faker::Address::zip_code }
    pais { "BRASIL"}
    phone_first { "(85) 9.9999.9999"}
    phone_second { "(85) 9.9999.9999"}
  end
end
