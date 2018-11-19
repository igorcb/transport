FactoryBot.define do
  factory :employee do
    tipo { Employee::TipoEmployee::FIXO }
    cpf { Faker::CPF.cpf }
    nome { Faker::Name.name }
    apelido { nome }
    cep { Faker::Address::zip_code }
    endereco { Faker::Address.street_name }
    numero { Faker::Address.building_number }
    complemento { Faker::Lorem.word }
    bairro { Faker::Lorem.word }
    cidade { Faker::Address.city }
    estado { Faker::Address.state_abbr }
  end
end
