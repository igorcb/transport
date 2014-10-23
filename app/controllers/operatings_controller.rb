class OperatingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_operating, only: [:show, :edit, :update, :destroy]

  # GET /operatings
  # GET /operatings.json
  def index
    @operatings = Operating.all
  end

  # GET /operatings/1
  # GET /operatings/1.json
  def show
  end

  # GET /operatings/new
  def new
    @operating = Operating.new
    @operating.operating_items.build
    @operating.assets.build
  end

  # GET /operatings/1/edit
  def edit
  end

  # POST /operatings
  # POST /operatings.json
  def create
    @operating = Operating.new(operating_params)

    respond_to do |format|
      if @operating.save 
        format.html { redirect_to @operating, flash: { success: "Operating was successfully created." } }
        format.json { render action: 'show', status: :created, location: @operating }
      else
        format.html { render action: 'new' }
        format.json { render json: @operating.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /operatings/1
  # PATCH/PUT /operatings/1.json
  def update
    respond_to do |format|
      if @operating.update(operating_params) 
        format.html { redirect_to @operating, flash: { success: "Operating was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @operating.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /operatings/1
  # DELETE /operatings/1.json
  def destroy
    @operating.destroy
    respond_to do |format|
      format.html { redirect_to operatings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_operating
      @operating = Operating.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def operating_params
      params.require(:operating).permit(:driver_id, :client_id, :data_chegada, :placa, :cte, :danfe, :qtde_volume, :peso, :observacao, :chave_cte, :chave_nfe, :responsavel_recebimento, :informacao_agendamento, :informacao_operacional, :responsavel_descarga, :valor, :fpgto, :avaria, :data_devolucao, :motivo_devolucao, :danfe_devolucao, 
        :observacao_edvolucao, :chave_danfe_devolucao,
        operating_items_attributes: [:operating_id, :product_id, :qtde, :unidade, :valor, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy]
        )
    end
end
