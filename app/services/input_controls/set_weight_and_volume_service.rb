module InputControls
  class SetWeightAndVolumeService

    def initialize(input_control)
      @input_control = input_control
    end

    def call
      #byebug
      weight = @input_control.nfe_xmls.sum("COALESCE(peso,0)")
      volume = @input_control.nfe_xmls.sum("COALESCE(volume,0)")
      amount = weight * cal_value_kg
      value_ton = calc_valor_tonelada
      value_kg = cal_value_kg
      begin
        ActiveRecord::Base.transaction do
          InputControl.where(id: @input_control).update_all(weight: weight, volume: volume, value_total: amount, value_ton: value_ton, value_kg: value_kg)
          return {success: true, message: "set weight and vokume process successful"}
        end
      rescue => e
        return {success: false, message: e.message}
      end
    end

    private
      # dia 01/10/2018 ajustar para 28 reais descarga por tonelada,
      # dia 15/07/2019 ajustar para 30 reais descarga por tonelada,
      # Verificar a possibilidade de mudar essa contante em variável
      # buscando da tabela de parametros do sistema
      VALOR_DA_TONELADA = 30
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
