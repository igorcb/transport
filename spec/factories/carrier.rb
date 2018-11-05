FactoryBot.define do
  factory :carrier do
    cnpj { Faker::CNPJ.cnpj }
    nome { Faker::Name.name }
    fantasia { nome }
    cep { Faker::Address::zip_code }
    endereco { Faker::Address.street_name }
    numero { Faker::Address.building_number }
    complemento { Faker::Lorem.word }
    bairro { Faker::Lorem.word }
    cidade { Faker::Address.city }
    estado { Faker::Address.state_abbr }
    inscricao_estadual { '000000' }
    inscricao_municipal { '000000' }
  end
end
