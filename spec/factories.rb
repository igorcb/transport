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
end