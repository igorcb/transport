class AdvanceMoney < ActiveRecord::Base

	def total_service_value
		OrdemServiceTypeService.joins(:ordem_service_table_price).where(advance_money_number: self.number).sum("ordem_service_table_prices.total_service").to_f
	end

	def balance_value
		(self.price.to_f - total_service_value.to_f).to_f
	end

	def ordem_service_type_services
		OrdemServiceTypeService.where(advance_money_number: self.number)
	end

end
