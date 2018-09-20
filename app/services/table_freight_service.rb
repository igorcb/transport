class TableFreightService
	
	def initialize(stretch_id, type_charge_id, eixos)
		@stretch_route = StretchRoute.where(id: stretch_id).first
		@type_charge_id = type_charge_id
    @eixos = eixos
	end

	def call
		freight_minimum = calc_freight_minimum(@type_charge_id, @stretch_route.distance.to_i, @eixos.to_i)
		{freight: freight_minimum.to_f}
	end

	private

	  def calc_freight_minimum(type = TableFreight::TypeCharge, km, eixo)
	    value = BigDecimal.new(0)
	    frete = TableFreight.where(type_charge: type).where("? between km_from and km_to", km).first
	    value = frete.price * km * eixo if frete.present?
	  end

end