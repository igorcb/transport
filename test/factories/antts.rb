# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :antt do
    rntrc "MyString"
    cpf_cnpj "MyString"
    nome "MyString"
    date_expiration "2018-07-23"
  end
end
