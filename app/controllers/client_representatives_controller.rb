class ClientRepresentativesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_client_representative, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  respond_to :html

  def new
    
  end
  
  def show
    respond_with(@client_representative)
  end

	def create
    client  = Client.find_by_cpf_cnpj(params[:client_cpf_cpnj])
    billing_client = Client.find_by_cpf_cnpj(params[:billing_client_cpf_cpnj])
    @client_representative = ClientRepresentative.new(client_representative_params)
    @client_representative.client_id = client.id
    @client_representative.billing_client_id = billing_client.id
    respond_to do |format|
      if @client_representative.save!
        format.html { redirect_to @client_representative, flash: { success: "Client was successfully created." } }
        format.json { render action: 'show', status: :created, location: @client_representative }
        format.js   { render action: 'show', status: :created, location: @client_representative }
      else
        format.html { render action: 'new' }
        format.json { render json: @client_representative.errors, status: :unprocessable_entity }
        format.js   { render json: @client_representative.errors, status: :unprocessable_entity }
      end
    end
 	end

  def destroy
    @client_representative = ClientRepresentative.find(params[:id])
    @representative = @client_representative.representative
    @client_representative.destroy
    #respond_with(@direct_charge)
    redirect_to @representative, flash: { success: "Client was successfully deleted." }
  end

	private
		def set_client_representative
      #@representative = Representative.find(params[:id])
		end

    def client_representative_params
      params.require(:client_representative).permit(:representative_id, :client_id, :billing_client)
    end

end
