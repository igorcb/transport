class TransferEquipamentsController < ApplicationController
  before_action :authenticate_user!
  #before_action :set_equipament, only: [:create]
  #load_and_authorize_resource

	def new
		@transfer_source = ControlPalletInternal.new
	end

	def create
		#@transfer = ControlPalletInternal.new(transfer_params)
		@transfer_source = ControlPalletInternal.new(transfer_params)
		@transfer_target = ControlPalletInternal.new(transfer_params)

		@transfer_source.responsable_id = params[:transfer_source][:source_responsable_id]
		#@transfer_source.responsable_type = params[:transfer_source][:responsable_type] 
		@transfer_source.type_account = params[:transfer_source][:source_type_account]
		@transfer_source.type_launche = ControlPalletInternal::CreditDebit::DEBIT
    @transfer_source.date_launche = params[:transfer_source][:date_launche]
		@transfer_source.equipament = params[:transfer_source][:equipament]
    @transfer_source.qtde = params[:transfer_source][:qtde]
    @transfer_source.historic = params[:transfer_source][:historic]
    @transfer_source.observation = params[:transfer_source][:observation]
		
		@transfer_target.responsable_id = params[:transfer_source][:target_responsable_id]
		#@transfer_target.responsable_type = params[:transfer_source][:responsable_type] 
		@transfer_target.type_account = params[:transfer_source][:target_type_account]
		@transfer_target.type_launche = ControlPalletInternal::CreditDebit::CREDIT
    @transfer_target.date_launche = params[:transfer_source][:date_launche]
		@transfer_target.equipament = params[:transfer_source][:equipament]
    @transfer_target.qtde = params[:transfer_source][:qtde]
    @transfer_target.historic = params[:transfer_source][:historic]
    @transfer_target.observation = params[:transfer_source][:observation]

  	respond_to do |format|
      if ControlPalletInternal.transfer(@transfer_source, @transfer_target)
        format.html { redirect_to control_pallet_internals_path, flash: { success: "Transfer was successfully created." } }
      else
      	flash[:danger] =  "There was an error transfer."
        format.html { render controller: 'transfer_equipament ', action: 'new', flash: { danger: "There was an error transfer." } }
      end
		end
	end

	private
		def set_equipament
			@transfer = ControlPalletInternal.find(params[:id])			
		end

    def transfer_params
      # params.require(:control_pallet_internal).permit(:responsable_type, :responsable_id, :type_account, :type_launche, :equipament, 
      # 	:date_launche, :qtde, :historic, :observation, :source_responsable_id, :target_responsable_id)
    end

end
