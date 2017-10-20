class EmployeesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_employee, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  def gallery
    @employee = Employee.find(params[:employee_id])
  end

  # GET /employees
  # GET /employees.json
  def index
    @employees = Employee.all
  end

  # GET /employees/1
  # GET /employees/1.json
  def show
  end

  # GET /employees/new
  def new
    @employee = Employee.new
    @employee.contacts.build
    @employee.assets.build
    @employee.table_prices.build
    @employee.specialty_employees.build
  end

  # GET /employees/1/edit
  def edit
  end

  # POST /employees
  # POST /employees.json
  def create
    @employee = Employee.new(employee_params)

    respond_to do |format|
      if @employee.save
        format.html { redirect_to @employee, flash: { success: "Employee was successfully created." } }
        format.json { render action: 'show', status: :created, location: @employee }
      else
        format.html { render action: 'new' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /employees/1
  # PATCH/PUT /employees/1.json
  def update
    respond_to do |format|
      if @employee.update(employee_params) 
        format.html { redirect_to @employee, flash: { success: "Employee was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @employee.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /employees/1
  # DELETE /employees/1.json
  def destroy
    if @employee.destroy
      respond_to do |format|
        format.html { redirect_to employees_url }
        format.json { head :no_content }
      end
    else
      flash[:danger] = "The deletion failed because: " + @employee.errors.full_messages.to_sentence
      redirect_to employees_url
    end
  end

  def get_employee_by_id
    @employee = Employee.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_employee
      @employee = Employee.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def employee_params
      params.require(:employee).permit(:cpf, :nome, :apelido, :endereco, :numero, :complemento, :bairro, :cidade, :estado, :cep, :tipo,
        :rg, :orgao_emissor, :data_emissao_rg, :avatar, :obs,
        contacts_attributes: [:contact, :tipo, :nome, :fone, :complemento, :id, :_destroy],
        table_prices_attributes: [:uf_tipo, :tipo, :valor, :id, :_destroy],
        emails_attributes: [:sector_id, :setor, :contato, :email, :responsavel_carga, :comprovante, :id, :_destroy],
        specialty_employees_attributes: [:specialty_id, :valor, :id, :_destroy],
        account_banks_attributes: [:banco, :nome_banco, :tipo_operacao, :agencia, :conta_corrente, :favorecido, :cpf_cnpj, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy])
    end
end


