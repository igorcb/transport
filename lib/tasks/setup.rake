require 'rake'
require 'database_cleaner'

namespace :test do

	title = "Development Test Automated."
	desc title
	puts "#{title}"

	namespace :db do
		body = "Populate database, setup initial."

		desc body
		puts " - #{body}"
		task :setup => [:environment] do |t, args|
			puts "Cleaned database, wait..."
			DatabaseCleaner.clean_with(:truncation)

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

			puts "   - Count: #{ConfigSystem.count}"

			company = FactoryBot.create(:company)

			puts "  - Create User"
			FactoryBot.create_list(:employee, 2)
      user_admin = FactoryBot.create(:user, employee: Employee.first)
      user_admin.add_role(:admin)
      user_oper = FactoryBot.create(:user, employee: Employee.last)
      user_oper.add_role(:oper)
			puts "   - Count: #{User.count}"

			#FactoryBot.create_list(:carrier, 2)
			FactoryBot.create(:carrier, cnpj: company.cnpj)
			FactoryBot.create(:carrier)
			FactoryBot.create(:group_client)
			FactoryBot.create(:owner)
			FactoryBot.create(:driver, user_created: User.first, user_updated: User.first)
			FactoryBot.create(:vehicle, user_created: User.first, user_updated: User.first)

      sectors = [
				'ADMINISTRATIVO',
				'COMERCIAL',
				'FINANCEIRO',
				'REPRESENTANTE',
				'OPERACIONAL',
				'PALLETS',
				'LOGISTICA_REVERSA',
				'REGISTROS_OCORRENCIA',
				'CONFIRMACAO_ENTREGA',
				'TAREFAS']

			puts "  - Create Sector"
			sectors.each { |sector| Sector.create!(name: sector) }
			puts "   - Count: #{Sector.count}"

			puts "  - Create Client"
			FactoryBot.create_list(:client, 3, user_created: User.first, user_updated: User.first)
			# Client.first.emails.create(FactoryBot.create(:email, sector_id: Sector::TypeSector::CONFIRMACAO_ENTREGA))
			# Client.second.emails.create(FactoryBot.create(:email))
			puts "   - Count: #{Client.count}"

			puts "  - Create InputControl"
			input_control = FactoryBot.create(:input_control)
			nfe_xml = FactoryBot.create(:nfe_xml, nfe_type: "InputControl", nfe_id: input_control.id)
			puts "   - Count: #{InputControl.count}"
			puts "   - NfeXml Count: #{NfeXml.count}"

			puts "  - Create OrdemService"
			#ordem_service = FactoryBot.create(:ordem_service)
			#"id"=>"2027", "nfe"=>{"ids"=>{"7418"=>"7418", "7417"=>"7417", "7419"=>"7419", "7420"=>"7420"}}
			#"id"=>"2027", "nfe"=>{"ids"=>{"7418"=>"7418"}}
			hash = {}
			hash_ids = {}
			hash_key_value = {}

			key = nfe_xml.id.to_s
			value = nfe_xml.id.to_s

			hash_key_value.store(key, value)
			hash_ids.store(:ids, hash_key_value)

			hash.store(:id, input_control.id)
			hash.store(:nfe, hash_ids)

			ids = OrdemService.get_hash_ids(hash[:nfe][:ids])

			InputControl.create_ordem_service_input_controls({id: input_control.id, nfe: ids})
			puts "   - Count: #{OrdemService.count}"
			puts "   - NfeKey Count: #{NfeKey.count}"
      ordem_service_first = OrdemService.first

			puts "  - Create Boarding"

			boarding = FactoryBot.create(:boarding)
			boarding.boarding_items.create(ordem_service_id: ordem_service_first.id, delivery_number: 1)
		end
	end
end

# namespace :db do
#   #namespace :test do
#     desc 'This task init setup fake data for test'
#     task setup_system: :environment do
#       FactoryBot.create(:employee, 2)
#       types = %i[admin oper]
#
#       user = create(:user, employee: Employee.fisrt)
#       user.add_role(:admin)
#       user = create(:user, employee: Employee.last)
#       user.add_role(:oper)
#
#       @current_user = User.first
#       FactoryBot.create(:group_client)
#       FactoryBot.create(:owner)
#       FactoryBot.create(:driver, user_created: @current_user, user_updated: @current_user)
#       FactoryBot.create_list(:client, 3, user_created: @current_user, user_updated: @current_user)
#       FactoryBot.create(:ordem_service, target_client_id: Client.first, source_client: Client.second, billing_client: Client.third)
#
#     end
#   #end
# end
