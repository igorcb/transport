module DirectCharges
  class SetWeightAndVolumeService

    def initialize(direct_charge)
      @direct_charge = direct_charge
    end

    def call
      weight = @direct_charge.nfe_xmls.sum(:peso)
      volume = @direct_charge.nfe_xmls.sum(:volume)
      amount = weight * cal_value_kg
      ActiveRecord::Base.transaction do
        DirectCharge.where(id: @direct_charge).update_all(weight: weight, volume: volume, value_total: amount)
        #return {success: true, message: "set weight and vokume process successful"}
      end
    end

    private
      VALOR_DA_TONELADA = 28
      def calc_valor_tonelada
      	VALOR_DA_TONELADA
      end

      def cal_value_kg
        valor = 0.00
      	valor = (VALOR_DA_TONELADA / 1000.00)
      	valor
      end

      def calc_value_total(weight)
        valor = 0.00
        valor = valor_kg * weight
        valor
      end
  end
end
