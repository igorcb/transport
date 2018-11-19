FactoryBot.define do
  factory :email do
    setor { Faker::Commerce.department(1) }
    contato { Faker::Name.name }
    email { Faker::Internet.email  }
    responsavel_carga {false}
    comprovante {false}
  end
end
