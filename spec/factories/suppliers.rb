FactoryGirl.define do
  factory :supplier do
    tipo_pessoa Supplier::TipoPessoa::FISICA
    cpf_cnpj '11111111111'
    nome 'IGOR C B - ME'
    fantasia 'I4 TECNOLOGIA'
    inscricao_estadual '00001'
    inscricao_municipal '900009'
    cep '60742300'
    endereco 'Rua Libania'
    numero '105'
    complemento 'nao existe'
    bairro 'Serrinha'
    cidade 'Fortaleza'
    estado 'CE'
  end
end
