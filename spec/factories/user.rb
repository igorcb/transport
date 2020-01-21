FactoryBot.define do
 factory :user do
    name     { Faker::Lorem.word }
    cpf      { Faker::CPF.cpf }
    email    { Faker::Internet.email }
    password { 'secret123' }
    active   { true }
    employee
 end

 factory :admin do
    name     { Faker::Lorem.word }
    cpf      { Faker::CPF.cpf }
    email    { Faker::Internet.email }
    password { 'secret123' }
    active   { true }
    employee
 end
end
