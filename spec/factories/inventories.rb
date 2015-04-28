# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :inventory do
    ordem_service nil
    descricao "MyString"
    qtde 1
    estado "MyString"
    valor "9.99"
  end
end
