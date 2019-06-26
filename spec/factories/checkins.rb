FactoryBot.define do
  factory :checkin do
    driver_cpf { Faker::CPF.cpf }
    driver_name { Faker::Name.unique.name }
    operation_type { "input_control" }
    status {"input"}
  end
end
