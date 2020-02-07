module OrdemServices
  class UpdateQtdePallet

    def initialize(ordem_service)
      @ordem_service = ordem_service
    end

    def call
      begin
        ActiveRecord::Base.transaction do
          nfes = @ordem_service.nfe_keys.pluck(:nfe)
          qtde_pallet = PalletizingPallets::PalletsByNfeService.new(nfes).call
          @ordem_service.update_attributes(qtde_pallet: qtde_pallet)
          return {success: true, message: "Palletizing finalized successful."}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end
    end
  end
end
