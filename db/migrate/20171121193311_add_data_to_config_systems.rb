class AddDataToConfigSystems < ActiveRecord::Migration[5.0]
  def data
    # ConfigSystem.create_with(config_key: "DRIVER_DEFAULT", config_value: "1", config_description: "Motorista padrão do sistema").find_or_create_by(config_key: "DRIVER_DEFAULT")
    # ConfigSystem.create_with(config_key: "CARRIER_DEFAULT", config_value: "1", config_description: "Transportadora padrão do sistema").find_or_create_by(config_key: "CARRIER_DEFAULT")
    # ConfigSystem.create_with(config_key: "HISTORIC_DEFAULT", config_value: "1", config_description: "Histórico padrão do sistema 'Nao definido' para aqueles lançamentos onde não é possível definir o histórico").find_or_create_by(config_key: "HISTORIC_DEFAULT")
    # ConfigSystem.create_with(config_key: "PAYMENT_METHOD_DEFAULT", config_value: "1", config_description: "Forma de Pagamento padrão do sistema.").find_or_create_by(config_key: "PAYMENT_METHOD_DEFAULT")
    # ConfigSystem.create_with(config_key: "COST_CENTER_DEFAULT", config_value: "1", config_description: "Centro de Custo padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "COST_CENTER_DEFAULT")
    # ConfigSystem.create_with(config_key: "SUB_COST_CENTER_DEFAULT", config_value: "1", config_description: "Sub Centro de Custo padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "SUB_COST_CENTER_DEFAULT")
    # ConfigSystem.create_with(config_key: "SUB_COST_CENTER_THREE_DEFAULT", config_value: "1", config_description: "Terceiro Sub Centro de Custo padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "SUB_COST_CENTER_THREE_DEFAULT")
    # ConfigSystem.create_with(config_key: "HISTORIC_RECEIVED_DISCHARGE_DEFAULT", config_value: "1", config_description: "Histórico padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "HISTORIC_RECEIVED_DISCHARGE_DEFAULT")
    # ConfigSystem.create_with(config_key: "ORDEM_SERVICE_COST_CENTER", config_value: "1", config_description: "Centro de Custo padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_COST_CENTER")
    # ConfigSystem.create_with(config_key: "ORDEM_SERVICE_SUB_COST_CENTER", config_value: "1", config_description: "Sub Centro de Custo padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_SUB_COST_CENTER")
    # ConfigSystem.create_with(config_key: "ORDEM_SERVICE_SUB_COST_CENTER_THREE", config_value: "1", config_description: "Terceiro Sub Centro de Custo padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_SUB_COST_CENTER_THREE")
    # ConfigSystem.create_with(config_key: "ORDEM_SERVICE_PAYMENT_METHOD", config_value: "1", config_description: "Forma de pagamento padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_PAYMENT_METHOD")
    #
    # Driver.create_with(cpf: "000.000.000-00", nome: "MOTORISTA NÃO IDENTIFICADO", fantasia: "MOTORISTA NÃO IDENTIFICADO", cep: "60.000-000", endereco: "Rua da cidade", numero: "s/n", bairro: "Centro", cidade: "Fortaleza", estado: "CE",
    #               rg: "000000000", orgao_expeditor: "SSP/CE", data_emissao_rg: "30/12/2099", data_nascimento: "30/12/1989", municipio_nascimento: "FORTALEZA", estado_nascimento: "CE", inss: "000", cnh: "000", registro_cnh: "0000",
    #               validade_cnh: "30/12/2099", categoria: "1",
    #               nome_do_pai: "PAI DO MOTORISTA", nome_da_mae: "MAE DO MOTORISTA").find_or_create_by(cpf: "000.000.000-00")
    # Carrier.create_with(cnpj: "00.000.000/0000-00", nome: "TRANSPORTADORA NÃO IDENTIFICADO", fantasia: "TRANSPORTADORA NÃO IDENTIFICADO", cep: "60.000-000", endereco: "Rua da cidade", numero: "s/n", bairro: "Centro", cidade: "Fortaleza", estado: "CE").find_or_create_by(cnpj: "00.000.000/0000-00")
    # Historic.find_or_create_by(descricao: "NÃO IDENTIFICADO")
    # PaymentMethod.find_or_create_by(descricao: "NÃO IDENTIFICADO")
    # cost_center = CostCenter.find_or_create_by(descricao: "ADMINISTRATIVO")
    # sub_cost_center = cost_center.sub_cost_centers.find_or_create_by(descricao: "ADMINISTRATIVO")
    # sub_cost_center_threes = cost_center.sub_cost_centers.find_or_create_by(descricao: 'ADMINISTRATIVO')
    
  end
end
