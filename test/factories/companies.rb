# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :company do
    razao_social "MyString"
    cnpj "MyString"
    inscricao_estadual "MyString"
    inscricao_municipal "MyString"
    endereco "MyString"
    numero "MyString"
    complemento "MyString"
    bairro "MyString"
    cidade "MyString"
    estado "MyString"
    cep "MyString"
    pais "MyString"
    phone_first "MyString"
    phone_second "MyString"
    observacao "MyText"
  end
end
