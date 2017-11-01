# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :representative do
    tipo_pessoa 1
    cpf_cnpj "MyString"
    nome "MyString"
    fantasia "MyString"
    inscricao_estadual "MyString"
    inscricao_municipal "MyString"
    endereco "MyString"
    numero "MyString"
    complemento "MyString"
    bairro "MyString"
    cidade "MyString"
    estado "MyString"
    rg "MyString"
    orgao_emissor "MyString"
    data_emissao "2017-11-01"
    observacao "MyText"
  end
end
