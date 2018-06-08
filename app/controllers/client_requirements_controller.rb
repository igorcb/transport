class ClientRequirementsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_client_requirement, only: [:show, :edit, :update, :destroy]
  before_action :find_client, only: [:new, :create, :index]
  load_and_authorize_resource

  def index
  end

  def new
    @client_requirement = @client.client_requirements.build
  end

  def create
    @client_source = Client.where(cpf_cnpj: params[:client_source_cnpj]).first
    @client_requirement = @client.client_requirements.build(client_requirement_params)    
    @client_requirement.client_source_id = @client_source.id if @client_source.present?

    respond_to do |format|
      if @client_requirement.save
        format.html { redirect_to [@client, @client_requirement] , flash: { success: "Client Requirement was successfully created." } }
        format.json { render action: 'show', status: :created, location: [@client, @client_requirement] }
        format.js   { render action: 'show', status: :created, location: [@client, @client_requirement] }
      else
        format.html { render action: 'new' }
        format.json { render json: @client_requirement.errors, status: :unprocessable_entity }
        format.js   { render json: @client_requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @client_requirement.update(client_requirement_params)
        format.html { redirect_to [@client, @client_requirement] , flash: { success: "Client Requirement was successfully updated." } }
        format.json { head :no_content }
        format.js   { render action: 'show', status: :created, location: [@client, @client_requirement] }
      else
        format.html { render action: 'edit' }
        format.json { render json: @client_requirement.errors, status: :unprocessable_entity }
        format.js   { render json: @client_requirement.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    def set_client_requirement
      find_client     
      @client_requirement = @client.client_requirements.where(id: params[:id]).first
    end

    def client_requirement_params
      params.require(:client_requirement).permit(:client_id, :type_vehicle, :type_body, :type_floor)
    end

    def find_client
      @client  = Client.find(params[:client_id])
    end  
end
