FactoryBot.define do
  factory :ordem_service do
    tipo { OrdemService::TipoOS::LOGISTICA }
    target_client_id { 1 }
    source_client_id { 1 }
    carrier
    carrier_entry_id { 1 }
    peso { 27000}
    qtde_volume { 600 }
    estado { 'CE' }
    cidade { 'FORTALEZA' }
    date_entry { Date.current }
    data { Date.current + 5.days}
    observacao { "" }
    valor_receita  { 0 }
    valor_despesas { 0 }
    valor_liquido  { 0 }
  end
end

  # factory :campaign do
  #   title         { FFaker::Lorem.word }
  #   description   { FFaker::Lorem.sentence }
  #   user
  #   status        { :pending }
  #   location        { "#{FFaker::Address.city}, #{FFaker::Address.street_address}"}
  #   event_date    { FFaker::Time.date }
  #   event_hour    { rand(24).to_s }
  # end
