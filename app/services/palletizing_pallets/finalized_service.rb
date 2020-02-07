module PalletizingPallets
  class FinalizedService

    def initialize(input_control, user)
      @input_control = input_control
      @palletizing = @input_control.palletizing
      @user = user
    end

    def call

      return {success: false, message: "Palletizing can't be blank."} if @palletizing.blank?
      return {success: false, message: "Palletizing can't user be blank."} if @palletizing.user.blank?

      begin
        ActiveRecord::Base.transaction do
          palletizing = Palletizing.update(@palletizing.id, status: :finished, finish: DateTime.now, user_finished_id: @user.id)
          @input_control.ordem_services.each do |ordem_service|
            nfes = ordem_service.nfe_keys.pluck(:nfe)
            qtde_pallet = PalletizingPallets::PalletsByNfeService.new(nfes).call
            ordem_service.update_attributes(qtde_pallet: qtde_pallet)
          end
          return {success: true, message: "Palletizing finalized successful."}
        end
      rescue => e
        puts e.message
        return {success: false, message: e.message}
      end

    end

  end
end
