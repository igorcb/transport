class TableInsuranceService
	
	def initialize(insurer_id, stretch_id, value_nf)
		#byebug
		@insurer = insurer_id
		@stretch_route = StretchRoute.where(id: stretch_id).first
		@value_nf = value_nf
	end

	def call
    table = TableInsurance.where(insurer_id: @insurer, state_source: "CE", state_target: "CE").first
		secure = calc_secure(table.percent, @value_nf)
		{ 
			secure: secure.to_f,
		 percent: table.percent.to_f
		}
	end

	private

	  def calc_secure(percent, value_nf)

			#return {secure: 0.00} if table.blank?

			value = (value_nf * percent.to_f) / 100
			value.to_f
	  end	
end