class ClientDischargesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_client_discharge, only: [:show, :edit, :update, :destroy]
  before_action :find_client, only: [:new, :create, :index]
  load_and_authorize_resource

  def index
  end

  def show

  end

  def new
  	@client_discharge = @client.client_discharges.build
  end

  def edit

  end

  def create
  	@client_source = Client.where(cpf_cnpj: params[:client_source_cnpj]).first
    @client_discharge = @client.client_discharges.build(client_discharge_params)  	
    @client_discharge.client_source_id = @client_source.id if @client_source.present?
    @client_discharge.created_user_id = current_user.id
    respond_to do |format|
      if @client_discharge.save
        format.html { redirect_to [@client, @client_discharge] , flash: { success: "Client Discharge was successfully created." } }
        format.json { render action: 'show', status: :created, location: [@client, @client_discharge] }
        format.js   { render action: 'show', status: :created, location: [@client, @client_discharge] }
      else
        format.html { render action: 'new' }
        format.json { render json: @client_discharge.errors, status: :unprocessable_entity }
        format.js   { render json: @client_discharge.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      @client_discharge.updated_user_id = current_user.id
      if @client_discharge.update(client_discharge_params)
        format.html { redirect_to [@client, @client_discharge] , flash: { success: "Client Discharge was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: [@client, @client_discharge] }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client_discharge.errors, status: :unprocessable_entity }
        format.js   { render json: @client_discharge.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  	def set_client_discharge
			find_client  		
  		@client_discharge = @client.client_discharges.where(id: params[:id]).first
  	end

    def client_discharge_params
      params.require(:client_discharge).permit(:client_id, :type_unit, :type_charge, :type_calc, :price)
    end

    def find_client
    	@client  = Client.find(params[:client_id])
    end
end
