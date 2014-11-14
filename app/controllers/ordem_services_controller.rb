class OrdemServicesController < ApplicationController
  before_action :set_ordem_service, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @ordem_services = OrdemService.all
    respond_with(@ordem_services)
  end

  def show
    respond_with(@ordem_service)
  end

  def new
    @ordem_service = OrdemService.new
    @ordem_service.ordem_service_type_service.build
    respond_with(@ordem_service)
  end

  def edit
  end

  def create
    @ordem_service = OrdemService.new(ordem_service_params)
    
    respond_to do |format|
      if @ordem_service.save 
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully created." } }
        format.json { render action: 'show', status: :created, location: @ordem_service }
      else
        format.html { render action: 'new' }
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @ordem_service.update(ordem_service_params) 
        format.html { redirect_to @ordem_service, flash: { success: "Ordem Service was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @ordem_service.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @ordem_service.destroy
    respond_with(@ordem_service)
  end

  private
    def set_ordem_service
      @ordem_service = OrdemService.find(params[:id])
    end

    def ordem_service_params
      params.require(:ordem_service).permit(:driver_id, :client_id, :data, :placa, :estado, :cidade, :cte, :danfe_cte, :nfe, :danfe_nfe, :valor_receita, :valor_despesas, :valor_liquido, :observacao, :status,
        ordem_service_type_service_attributes: [:ordem_service_id, :type_service_id, :valor, :id, :_destroy]
        )
    end
end
