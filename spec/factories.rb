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

  factory :group_client do
    sequence(:descricao)  { |n| "L7 #{n}" }
  end

  factory :client do
    tipo_pessoa Client::TipoPessoa::FISICA
    cpf_cnpj '00000000000000'
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
    rg '93000210'
    orgao_emissor 'SSP/CE'
    hora_descarga ''
    condicao_recebimento ''
    group_client_id :group_client
    valor_volume '10'
    valor_peso '9000'
  end

  #factory :contact do
  #  tipo Contact::TipoContato::FIXO
  #  nome "Joao"
  #  fone "8532326790"
  #  complemento ""
  #  association :assunto, factory: :client
  #end

  factory :driver do
    cpf '00000000000'
    nome 'IGOR C BATISTA'
    fantasia 'IGOR'
    cep '60742300'
    endereco 'Rua Libania'
    numero '105'
    complemento ''
    bairro 'Serrinha'
    cidade 'Fortaleza'
    estado 'CE'
    rg '92002099618'
    orgao_expeditor 'SSP/CE'
    data_emissao_rg '2014-09-09'
    data_nascimento '1980-09-02'
    municipio_nascimento 'Fortaleza'
    estado_nascimento 'CE'
    inss '000'
    cnh '00525878207'
    registro_cnh '99999999'
    categoria Driver::Categoria::B
    validade_cnh '2014-09-09'
    nome_do_pai 'JOSE JURENVILLE LIMA BATISTA'
    nome_da_mae 'MARIA CORDEIRO BATISTA'
  end

  factory :driver_delivery do
    cpf '11111111111'
    nome 'IAN TRANSPORTES'
    fantasia 'IAN TRANSPORTES'
    cep '60742300'
    endereco 'Rua Libania'
    numero '105'
    complemento ''
    bairro 'Serrinha'
    cidade 'Fortaleza'
    estado 'CE'
    rg '92002099618'
    orgao_expeditor 'SSP/CE'
    data_emissao_rg '2014-09-09'
    data_nascimento '1980-09-02'
    municipio_nascimento 'Fortaleza'
    estado_nascimento 'CE'
    inss '000'
    cnh '00525878207'
    registro_cnh '99999999'
    categoria Driver::Categoria::E
    validade_cnh '2016-01-01'
    nome_do_pai 'IGOR C. BATISTA'
    nome_da_mae 'MARIA IMACULADA DE BARROS SILVA'
  end

  factory :carrier do
    cnpj '00000000000000'
    inscricao_municipal nil
    inscricao_estadual nil
    nome 'IGOR C B - ME'
    fantasia 'I4 TECNOLOGIA'
    cep '60742300'
    endereco 'Rua Libania'
    numero '105'
    complemento nil
    bairro 'Serrinha'
    cidade 'Fortaleza'
    estado 'CE'
  end

  factory :agent, class: Carrier do
    cnpj '50864651000106'
    inscricao_municipal nil
    inscricao_estadual '679029397'
    nome 'Leonardo e Guilherme Assessoria Jurídica Ltda'
    fantasia 'Leonardo e Guilherme Assessoria Jurídica Ltda'
    cep '61610155'
    endereco 'Rua Dutra'
    numero '333'
    complemento nil
    bairro 'Padre Julio Maria'
    cidade 'Caucaia'
    estado 'CE'    
    aereo false
  end

  factory :agent_target, class: Carrier do
    cnpj '67100137000199'
    inscricao_municipal nil
    inscricao_estadual '679029397'
    nome 'Camila e Henry Telas ME'
    fantasia 'Camila e Henry Telas ME'
    cep '60742300'
    endereco 'Rua Vila Sousa'
    numero '868'
    complemento nil
    bairro 'Bom Jardim'
    cidade 'Fortaleza'
    estado 'CE'    
    aereo false
  end

  factory :airline, class: Carrier do
    cnpj '07575651/000825'
    inscricao_municipal nil
    inscricao_estadual '062114158'
    nome 'VRG LINHAS AEREAS S.A.'
    fantasia 'GOL LOG'
    cep '60741970'
    endereco 'Av. Senador Carlos Jereissati'
    numero '3000'
    complemento 'Terminal de Cargas Aeroporto Pinto'
    bairro 'Serrinha'
    cidade 'Fortaleza'
    estado 'CE' 
    aereo true   
  end

  factory :ordem_service do
    client_id :client
    data '2014-12-01'
    estado 'CE'
    cidade 'FORTALEZA'
    cte '0000001'
    danfe_cte '0000001'
    status OrdemService::TipoStatus::ABERTO
    data_fechamento '2014-12-01'
    qtde_volume 1.001
    peso 1.002
    data_entrega_servico '2014-12-01'
    senha_sefaz 'a12zlkx'
    tipo OrdemService::TipoOS::LOGISTICA
  end

  factory :ordem_service_air, class: OrdemService do
    client_id :client
    carrier_id :agent
    data '2014-12-01'
    estado 'CE'
    cidade 'FORTALEZA'
    cte '0000001'
    danfe_cte '0000001'
    status OrdemService::TipoStatus::ABERTO
    data_fechamento '2014-12-01'
    qtde_volume 1.001
    peso 1.002
    data_entrega_servico '2014-12-01'
    senha_sefaz 'a12zlkx'
    tipo OrdemService::TipoOS::LOGISTICA
  end

  factory :stretch do
    cidade 'SAO PAULO'
    estado 'SP'
    destino 'FOR'
  end

  factory :stretch_source, class: Stretch do
    cidade 'BELEM'
    estado 'PA'
    destino 'BEL'
  end  

  factory :stretch_target, class: Stretch do
    cidade 'BELEM'
    estado 'PA'
    destino 'BEL'
  end  

end
