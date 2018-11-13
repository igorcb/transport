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

			puts "  - Create User"
			FactoryBot.create_list(:employee, 2)
      user_admin = FactoryBot.create(:user, employee: Employee.first)
      user_admin.add_role(:admin)
      user_oper = FactoryBot.create(:user, employee: Employee.last)
      user_oper.add_role(:oper)
			puts "   - Count: #{User.count}"

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

			puts "  - Create Ordem Service"
			ordem_service = FactoryBot.create(:ordem_service)
			puts "   - Count: #{OrdemService.count}"

			puts "  - Create Boarding"
			boarding = FactoryBot.create(:boarding)
			boarding.boarding_items.create(ordem_service_id: ordem_service.id, delivery_number: 1)
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
