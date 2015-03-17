namespace :db do
	desc "Migrate service order for service order logistics"
	task ordem_services: :environment do
		OrdemService.where(tipo: 0).each	do |os|
			ActiveRecord::Base.transaction do
				OrdemServiceLogistic.create!(
					  ordem_service_id: os.id,
					  driver_id: os.driver_id,
					  delivery_driver_id: os.delivery_driver_id,
						placa: os.placa,
						qtde_volume: os.qtde_volume,
						peso: os.peso,
						senha_sefaz: os.senha_sefaz
					)
			  CteKey.create!(cte: os.cte, chave: os.danfe_cte, cte_id: os.id, cte_type: "OrdemService") if os.cte.present?
			end
		end
		OrdemService.where(tipo: 0).update_all(tipo: 1)
	end
end
