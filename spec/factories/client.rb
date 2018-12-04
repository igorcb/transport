FactoryBot.define do
  factory :client do
    association :group_client, factory: :group_client 
    tipo_cliente { Client::TipoCliente::NORMAL }
    tipo_pessoa { Client::TipoPessoa::JURIDICA }
    cpf_cnpj { Faker::CNPJ.cnpj }
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
    faturar_cada { 30 }
    vencimento_para { 30 }
    qtde_parcela { 1 }
  end
end
