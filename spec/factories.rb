FactoryGirl.define do
  factory :address do
    tipo     "1"
    logradouro    "Rua libania"
    bairro "serrinha"
    estado "CE"
    cidade "fortaleza"
    cep "60742300"
  end

  factory :person do
    cpf_cnpj '00000000000000'
    nome 'IGOR C B - ME'
    fantasia 'I4 TECNOLOGIA'
    address_id :address
    numero '102'
    complemento 'prox a pague menos'  	
  end

  factory :client do
    tipo_pessoa Client::TipoPessoa::FISICA
    cpf_cnpj '00000000000000'
    nome 'IGOR C B - ME'
    fantasia 'I4 TECNOLOGIA'
    cep '60742300'
    endereco 'Rua Libania'
    numero '105'
    bairro 'Serrinha'
    cidade 'Fortaleza'
    estado 'CE'
  end

  #factory :contact do
  #  tipo Contact::TipoContato::FIXO
  #  nome "Joao"
  #  fone "8532326790"
  #  complemento ""
  #  association :assunto, factory: :client
  #end

end