class CarrierCredentialsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client_discharge, only: [:show, :edit, :update, :destroy]
  before_action :find_carrier, only: [:new, :create, :index]
  load_and_authorize_resource

  def index

  end

  def show

  end

  def new
  	#@carrier_credential = @carrier.credentials.build
  end

  def create
  	@credential = Carrier.where(cnpj: params[:carrier_credential_cnpj]).first
    @carrier_credential = @carrier.credentials.build
    @carrier_credential.carrier_credential_id = @credential.id if @credential.present?
    #@client_discharge.created_user_id = current_user.id
    respond_to do |format|
      if @carrier_credential.save
        format.html { redirect_to [@carrier, @carrier_credential] , flash: { success: "Carrier Credential was successfully created." } }
        #format.json { render action: 'show', status: :created, location: [@carrier, @carrier_credential] }
        #format.js   { render action: 'show', status: :created, location: [@carrier, @carrier_credential] }
      else
        format.html { render action: 'new' }
        format.json { render json: @carrier_credential.errors, status: :unprocessable_entity }
        format.js   { render json: @carrier_credential.errors, status: :unprocessable_entity }
      end
    end  
  end

	private

		def set_client_discharge
			find_carrier  		
  		@carrier_credential = @carrier.credentials.where(id: params[:id]).first			
		end

		def find_carrier
			@carrier  = Carrier.find(params[:carrier_id])
		end

		def carrier_credential_params
			#params.require(:carrier_credential).permit(:carrier_credential_id, :carrier_credential_cnpj)
		end

end