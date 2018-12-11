FactoryBot.define do
  number_chave = (0...44).map { rand(0..9) }.join
  factory :nfe_xml do
    status { NfeXml::TipoStatus::NAO_PROCESSADO }
    error { NfeXml::TipoError::SEM_ERROR }
    equipamento { NfeXml::TipoEquipamento::NOTA_FISCAL  }
    create_os { NfeXml::TipoOsCriada::NAO }
    asset_file_name { number_chave }
    numero { (0...9).map { rand(0..9) }.join }
    chave { number_chave }
    association :target_client, factory: :client
    association :source_client, factory: :client
    # target_client_id { 1 }
    # source_client_id { 1 }

    # asset_content_type
    # asset_file_size
    # asset_updated_at
    # created_at
    # updated_at
    # nfe_id
    # nfe_type
    # peso
    # volume
    # valor_nota

    # create_os
    # peso_liquido
    # observation
    # place
    # action_inspector_number
    # action_inspector_file_name
    # action_inspector_content_type
    # action_inspector_file_size
    # action_inspector_updated_at
    # action_inspector_user_confirmed_id
    # action_inspector_updated_confirmed
    # take_dae"
  end
end
