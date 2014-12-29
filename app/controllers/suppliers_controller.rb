class SuppliersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_supplier, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /suppliers
  # GET /suppliers.json
  def index
    @suppliers = Supplier.all
  end

  # GET /suppliers/1
  # GET /suppliers/1.json
  def show
  end

  # GET /suppliers/new
  def new
    @supplier = Supplier.new
    @supplier.contacts.build
    @supplier.emails.build
    @supplier.assets.build
    @supplier.movement_activities.build
  end

  # GET /suppliers/1/edit
  def edit
  end

  # POST /suppliers
  # POST /suppliers.json
  def create
    @supplier = Supplier.new(supplier_params)

    respond_to do |format|
      if @supplier.save
        format.html { redirect_to @supplier, flash: { success: "Supplier was successfully created." } }
        format.json { render action: 'show', status: :created, location: @supplier }
      else
        format.html { render action: 'new' }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /suppliers/1
  # PATCH/PUT /suppliers/1.json
  def update
    respond_to do |format|
      if @supplier.update(supplier_params)
        format.html { redirect_to @supplier, flash: { success: "Supplier was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @supplier.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /suppliers/1
  # DELETE /suppliers/1.json
  def destroy
    if @supplier.destroy
      respond_to do |format|
        format.html { redirect_to suppliers_url }
        format.json { head :no_content }
      end
    else
      flash[:danger] = "The deletion failed because: " + @supplier.errors.full_messages.to_sentence
      redirect_to suppliers_url
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_supplier
      @supplier = Supplier.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def supplier_params
      params.require(:supplier).permit(:cpf_cnpj, :nome, :fantasia, :inscricao_estadual, :instricao_municipal, :endereco, :numero, :complemento, :bairro, :cidade, :estado, :cep, :tipo_pessoa, :obs,
        emails_attributes: [:setor, :contato, :email, :id, :_destroy],
        contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy],
        movement_activities_attributes: [:activity_id, :id, :_destroy]
        )
    end
end
