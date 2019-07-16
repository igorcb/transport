module OrdemServices
  class SetWeightAndVolumeService

    def initialize(ordem_service)
      @ordem_service = ordem_service
    end

    def call
      weight = @ordem_service.nfe_keys.sum(:peso)
      volume = @ordem_service.nfe_keys.sum(:volume)
      amount = weight * cal_value_kg
      ActiveRecord::Base.transaction do
        OrdemService.where(id: @ordem_service).update_all(peso: weight, qtde_volume: volume)
        OrdemServiceLogistic.where(ordem_service_id: @ordem_service.id).update_all(peso: weight, qtde_volume: volume)
        #return {success: true, message: "set weight and vokume process successful"}
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
