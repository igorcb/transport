class TableIcmsService
	
	def initialize(stretch_id, value)
		@stretch_route = StretchRoute.where(id: stretch_id).first
		@value = value
	end

	def call
    table = TableIcms.where(state_source: "CE", state_target: "CE").first
		icms = calc_icms(@value, table.aliquot)
		{ 
			icms: icms.to_f,
		 percent: table.aliquot.to_f
		}
	end

	private

	  def calc_icms(value, percent)
	    perc_icms = 1 - ( percent / 100) 
	    value_icms = ((value) / perc_icms) - (value) 
	    value_icms
	  end

end