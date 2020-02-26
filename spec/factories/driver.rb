FactoryBot.define do
  factory :driver do
    cpf { Faker::CPF.cpf }
    nome { Faker::Name.name }
    fantasia { nome }
    cep { Faker::Address::zip_code }
    endereco { Faker::Address.street_name }
    numero { Faker::Address.building_number }
    complemento { Faker::Lorem.word }
    bairro { Faker::Lorem.word }
    cidade { Faker::Address.city }
    estado { Faker::Address.state_abbr }
    rg { '000000' }
    orgao_expeditor { '000000' }
    data_emissao_rg { Faker::Date.backward }
    data_nascimento { Faker::Date.between(from: '1970-01-01', to: '1980-12-31') }
    municipio_nascimento { Faker::Address.city }
    estado_nascimento { Faker::Address.state_abbr }
    estado_civil { Driver::EstadoCivil::SOLTEIRO }
    cor_da_pele { Driver::CorDaPele::INDIGENA }
    tipo_contrato { Driver::TipoContrato::TERCEIRIZADO }
    inss  { '000000' }
    cnh { '000000' }
    validade_cnh { Faker::Date.forward }
    registro_cnh { '000000' }
    categoria { Driver::Categoria::E }
    nome_do_pai { Faker::Name.name }
    nome_da_mae { Faker::Name.name }
    user_created factory: :user
    user_updated_id  { User.first.id }
  end
end
