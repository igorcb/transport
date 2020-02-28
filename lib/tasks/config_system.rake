require 'rake'
require 'database_cleaner'
require 'faker'

namespace :db do
	desc "population database"
	task :config_system, [:tenant] => [:environment] do |t, args|
    puts "Load image rails"
    image  = File.open(File.join(Rails.root,'public/rails_img.jpg'))
		Apartment::Tenant.switch!(args.tenant)

		puts "Cleaned database #{args.environment}, wait..."
		DatabaseCleaner.clean_with(:truncation)

		puts "  - Create Company"
		company = FactoryBot.create(:company)

		puts "  - Config System"
		ConfigSystem.create_with(config_key: "DRIVER_DEFAULT", config_value: "1", config_description: "Motorista padrão do sistema").find_or_create_by(config_key: "DRIVER_DEFAULT")
		ConfigSystem.create_with(config_key: "CARRIER_DEFAULT", config_value: "1", config_description: "Transportadora padrão do sistema").find_or_create_by(config_key: "CARRIER_DEFAULT")
		ConfigSystem.create_with(config_key: "HISTORIC_DEFAULT", config_value: "1", config_description: "Histórico padrão do sistema 'Nao definido' para aqueles lançamentos onde não é possível definir o histórico").find_or_create_by(config_key: "HISTORIC_DEFAULT")
		ConfigSystem.create_with(config_key: "PAYMENT_METHOD_DEFAULT", config_value: "1", config_description: "Forma de Pagamento padrão do sistema.").find_or_create_by(config_key: "PAYMENT_METHOD_DEFAULT")
		ConfigSystem.create_with(config_key: "COST_CENTER_DEFAULT", config_value: "1", config_description: "Centro de Custo padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "COST_CENTER_DEFAULT")
		ConfigSystem.create_with(config_key: "SUB_COST_CENTER_DEFAULT", config_value: "1", config_description: "Sub Centro de Custo padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "SUB_COST_CENTER_DEFAULT")
		ConfigSystem.create_with(config_key: "SUB_COST_CENTER_THREE_DEFAULT", config_value: "1", config_description: "Terceiro Sub Centro de Custo padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "SUB_COST_CENTER_THREE_DEFAULT")
		ConfigSystem.create_with(config_key: "HISTORIC_RECEIVED_DISCHARGE_DEFAULT", config_value: "1", config_description: "Histórico padrão do sistema para criar um contas a receber quando for finalizado a digitação da remessa de entrada").find_or_create_by(config_key: "HISTORIC_RECEIVED_DISCHARGE_DEFAULT")
		ConfigSystem.create_with(config_key: "ORDEM_SERVICE_COST_CENTER", config_value: "1", config_description: "Centro de Custo padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_COST_CENTER")
		ConfigSystem.create_with(config_key: "ORDEM_SERVICE_SUB_COST_CENTER", config_value: "1", config_description: "Sub Centro de Custo padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_SUB_COST_CENTER")
		ConfigSystem.create_with(config_key: "ORDEM_SERVICE_SUB_COST_CENTER_THREE", config_value: "1", config_description: "Terceiro Sub Centro de Custo padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_SUB_COST_CENTER_THREE")
		ConfigSystem.create_with(config_key: "ORDEM_SERVICE_PAYMENT_METHOD", config_value: "1", config_description: "Forma de pagamento padrão do sistema para quando fechar uma ordem de serviço gerar o contas a receber").find_or_create_by(config_key: "ORDEM_SERVICE_PAYMENT_METHOD")
		ConfigSystem.create_with(config_key: "PAYMENT_DISCHARGE_COST_CENTER", config_value: "1", config_description: "Centro de custo padrão para quando solicita pagamento de descarga no embarque, gerar o contas a pagar.").find_or_create_by(config_key: "PAYMENT_DISCHARGE_COST_CENTER")
		ConfigSystem.create_with(config_key: "PAYMENT_DISCHARGE_SUB_COST_CENTER", config_value: "1", config_description: "Sub Centro de custo padrão para quando solicita pagamento de descarga no embarque, gerar o contas a pagar").find_or_create_by(config_key: "PAYMENT_DISCHARGE_SUB_COST_CENTER")
		ConfigSystem.create_with(config_key: "PAYMENT_DISCHARGE_SUB_COST_CENTER_THREE", config_value: "1", config_description: "Terceiro Nível Sub Centro de custo padrão para quando solicita pagamento de descargano embarque, gerar o contas a pagar.").find_or_create_by(config_key: "PAYMENT_DISCHARGE_SUB_COST_CENTER_THREE")
		ConfigSystem.create_with(config_key: "EMAIL_USER_PRODUCT_NOTIFICATION", config_value: "admin@admin.com.br", config_description: "E-mail responsável para informar a qtde pallet, calculado automaticamente pelo sistema, na leitura do XML. Enviar notificação quando um registro de produto for novo no banco de dados..").find_or_create_by(config_key: "EMAIL_USER_PRODUCT_NOTIFICATION")
		ConfigSystem.create_with(config_key: "VALUE_DISCHARGE_OPERATION", config_value: "0.93", config_description: "Configuração para calculo de pagamento de descarga do operacional.").find_or_create_by(config_key: "VALUE_DISCHARGE_OPERATION")
		puts "   - Count: #{ConfigSystem.count}"

		puts "  - Create User"
		FactoryBot.create_list(:employee, 2)
		user_admin = FactoryBot.create(:user, employee: Employee.first)
		user_admin.add_role(:admin)
		user_oper = FactoryBot.create(:user, employee: Employee.last)
		user_oper.add_role(:oper)
		puts "   - Count: #{User.count}"

		puts "  - Create Driver"
		Driver.create_with(cpf: "000.000.000-00", nome: "MOTORISTA NÃO IDENTIFICADO", fantasia: "MOTORISTA NÃO IDENTIFICADO", cep: "60.000-000", endereco: "Rua da cidade", numero: "s/n", bairro: "Centro", cidade: "Fortaleza", estado: "CE",
		                  rg: "000000000", orgao_expeditor: "SSP/CE", data_emissao_rg: "30/12/2099", data_nascimento: "30/12/1989", municipio_nascimento: "FORTALEZA", estado_nascimento: "CE", inss: "000", cnh: "000", registro_cnh: "0000",
		                  validade_cnh: "30/12/2099", categoria: "1",
		                  nome_do_pai: "PAI DO MOTORISTA", nome_da_mae: "MAE DO MOTORISTA").find_or_create_by(cpf: "000.000.000-00")
		puts "   - Count: #{Driver.count}"

		puts "  - Create Carrier"
    Carrier.create_with(cnpj: "00.000.000/0000-00", nome: "TRANSPORTADORA NÃO IDENTIFICADO", fantasia: "TRANSPORTADORA NÃO IDENTIFICADO", cep: "60.000-000", endereco: "Rua da cidade", numero: "s/n", bairro: "Centro", cidade: "Fortaleza", estado: "CE").find_or_create_by(cnpj: "00.000.000/0000-00")
		puts "  - Create Historic"
    Historic.find_or_create_by(descricao: "NÃO IDENTIFICADO")
		puts "  - Create PaymentMethod"
    PaymentMethod.find_or_create_by(descricao: "NÃO IDENTIFICADO")

		puts "  - Create CostCenter, SubCostCenter, SubCostCenterThrees"
    cost_center = CostCenter.find_or_create_by(descricao: "ADMINISTRATIVO")
    sub_cost_center = cost_center.sub_cost_centers.find_or_create_by(descricao: "ADMINISTRATIVO")
    sub_cost_center_threes = cost_center.sub_cost_centers.find_or_create_by(descricao: 'ADMINISTRATIVO')

		puts "  - Create Sectors"
 		Sector.find_or_create_by(name: "ADMINISTRATIVO")
 		Sector.find_or_create_by(name: "COMERCIAL")
 		Sector.find_or_create_by(name: "FINANCEIRO")
 		Sector.find_or_create_by(name: "REPRESENTANTE")
 		Sector.find_or_create_by(name: "OPERACIONAL")
 		Sector.find_or_create_by(name: "PALLETS")
 		Sector.find_or_create_by(name: "LOGISTICA_REVERSA")
 		Sector.find_or_create_by(name: "REGISTROS_OCORRENCIA")
 		Sector.find_or_create_by(name: "CONFIRMACAO_ENTREGA")
 		puts "   - Count: #{Sector.count}"

		puts "  - Create Carrier"
		Carrier.create_with(cnpj: "00.000.000/0000-00", nome: "TRANSPORTADORA NÃO IDENTIFICADO", fantasia: "TRANSPORTADORA NÃO IDENTIFICADO", cep: "60.000-000", endereco: "Rua da cidade", numero: "s/n", bairro: "Centro", cidade: "Fortaleza", estado: "CE").find_or_create_by(cnpj: "00.000.000/0000-00")
		FactoryBot.create(:carrier, cnpj: company.cnpj)
		FactoryBot.create(:carrier)
		puts "   - Count: #{Carrier.count}"

		puts "  - Group Client"
		FactoryBot.create(:group_client)
		puts "  - Group Owner"
		FactoryBot.create(:owner)

		puts "  - Create Client"
		FactoryBot.create_list(:client, 3, user_created: User.first, user_updated: User.first)
		#Client.first.emails.create(FactoryBot.create(:email, sector_id: Sector::TypeSector::CONFIRMACAO_ENTREGA))
		#Client.second.emails.create(FactoryBot.create(:email))
		puts "   - Count: #{Client.count}"

	end
end
