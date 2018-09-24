class TableInsuranceService
	
	def initialize(insurer_id, stretch_id, value_nf)
		@insurer = insurer_id
		@stretch_route = StretchRoute.includes(:stretch_source, :stretch_source).where(id: stretch_id).first
		@value_nf = value_nf
	end

	def call
    table = TableInsurance.where(insurer_id: @insurer, state_source: @stretch_route.stretch_source.estado, state_target: @stretch_route.stretch_target.estado).first
		percent = table.present? ? table.percent : 0
		secure = calc_secure(percent, @value_nf)
		{ 
			secure: secure.to_f,
		 percent: percent.to_f
		}
	end

	private

	  def calc_secure(percent, value_nf)

			#return {secure: 0.00} if table.blank?

			value = (value_nf * percent.to_f) / 100
			value.to_f
	  end	
end