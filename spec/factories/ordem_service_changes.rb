# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ordem_service_change do
    ordem_service nil
    source_cep "MyString"
    source_numero "MyString"
    source_complemento "MyString"
    source_endereco_completo "MyString"
    source_endereco "MyString"
    source_bairro "MyString"
    source_cidade "MyString"
    source_estado "MyString"
    target_cep "MyString"
    target_numero "MyString"
    target_complemento "MyString"
    target_endereco "MyString"
    target_bairro "MyString"
    target_cidade "MyString"
    target_estado "MyString"
    placa "MyString"
    driver nil
    compartilhado false
    cubagem "9.99"
    valor_declarado "9.99"
    valor_total "9.99"
  end
end
