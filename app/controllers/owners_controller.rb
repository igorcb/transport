class OwnersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_owner, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /owners
  # GET /owners.json
  def index
    @owners = Owner.all
  end

  # GET /owners/1
  # GET /owners/1.json
  def show
  end

  # GET /owners/new
  def new
    @owner = Owner.new
    @owner.contacts.build
    @owner.emails.build
    @owner.ownerships.build
  end

  # GET /owners/1/edit
  def edit
  end

  # POST /owners
  # POST /owners.json
  def create
    @owner = Owner.new(owner_params)

    respond_to do |format|
      if @owner.save
        format.html { redirect_to @owner, flash: { success: "Owner was successfully created." } }
        format.json { render action: 'show', status: :created, location: @owner }
      else
        format.html { render action: 'new' }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /owners/1
  # PATCH/PUT /owners/1.json
  def update
    respond_to do |format|
      if @owner.update(owner_params)
        format.html { redirect_to @owner, flash: { success: "Owner was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @owner.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /owners/1
  # DELETE /owners/1.json
  def destroy
    @owner.destroy
    respond_to do |format|
      format.html { redirect_to owners_url }
      format.json { head :no_content }
    end
  end

  def get_owner_by_cpf_cnpj
    @owner = Owner.find_by_cpf_cnpj(params[:cpf_cpnj])
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_owner
      @owner = Owner.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def owner_params
      params.require(:owner).permit(:cpf_cnpj, :rg, :data_emissao, :orgao_emissor, :nome, :fantasia, :inscricao_estadual, :instricao_municipal,
        :endereco, :numero, :complemento, :bairro, :cidade, :estado, :cep, :obs, 
        emails_attributes: [:setor, :contato, :email, :comprovante, :id, :_destroy],
        contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
        ownerships_attributes: [:vehicle_id, :id, :_destroy]
        )
    end
end
