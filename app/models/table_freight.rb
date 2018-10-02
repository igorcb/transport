class TableFreight < ActiveRecord::Base
  validates :type_charge, presence: true
  validates :km_from, presence: true, :numericality => { :only_integer => true }
  validates :km_from, presence: true, :numericality => { :only_integer => true }
  validates :price, presence: true, numericality: { greater_than: 0 }

  module TypeCharge
		CARGA_GERAL = 0
		CARGA_GRANEL = 1
		CARGA_NEOGRANEL = 2
		CARGA_FRIGORIFICADA = 3
		CARGA_PERIGOSA = 4
  end

  module TypeSellerCommission
    FREIGHT = 0
    LUCRE_GROSS = 1
  end

  def type_charge_name
    case self.type_charge
      when 0 then "Carga Geral"
      when 1 then "Carga Granel"
      when 2 then "Carga Neo Granel"
      when 3 then "Carga Frigorificada"
      when 4 then "Carga Perigosa"
    else "Nao Definido"
    end
  end

  def self.calc_freight_minimum(type = TableFreight::TypeCharge, km, eixo)
    value = BigDecimal.new(0)
    frete = TableFreight.where(type_charge: type).where("? between km_from and km_to", km).first
    value = frete.price * km * eixo if frete.present?
  end

  def self.payment_method(params)
    case params.to_i
      when 0 then "A Vista"
      when 1 then "5 Dias" 
      when 2 then "10 Dias"
      when 3 then "20 Dias"
      when 4 then "30 Dias"
      when 5 then "45 Dias"
    end
  end
end
