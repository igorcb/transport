class PalletsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_pallet, only: [:show, :edit, :update, :destroy, :driver_select]

  load_and_authorize_resource

  #respond_to :html, :js, :json

  # GET /pallets
  # GET /pallets.json
  def index
    @pallets = Pallet.all
  end

  # GET /pallets/1
  # GET /pallets/1.json
  def show
  end

  # GET /pallets/new
  def new
    @pallet = Pallet.new
  end

  # GET /pallets/1/edit
  def edit
  end

  # POST /pallets
  # POST /pallets.json
  def create
    client = Client.find_by_cpf_cnpj(params[:client_cpf_cpnj])
    @pallet = Pallet.new(pallet_params)
    @pallet.client_id = client.id

    respond_to do |format|
      if @pallet.save
        format.html { redirect_to @pallet, flash: { success: "Pallet was successfully created." }  }
        format.json { render action: 'show', status: :created, location: @pallet }
      else
        format.html { render action: 'new' }
        format.json { render json: @pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /pallets/1
  # PATCH/PUT /pallets/1.json
  def update
    respond_to do |format|
      if @pallet.update(pallet_params)
        format.html { redirect_to @pallet, flash: { success: "Pallet was successfully updated." }  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @pallet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pallets/1
  # DELETE /pallets/1.json
  def destroy
    @pallet.destroy
    respond_to do |format|
      format.html { redirect_to pallets_url }
      format.json { head :no_content }
    end
  end
  
  def estoque

  end
  
  def driver_select
    puts ">>>>>>>>>>>>>> ordem de serviço já criada?: #{@pallet.ordem_service.present? }"
    if @pallet.ordem_service.present? 
      flash[:danger] = "Ordem Service has already been created."
      redirect_to @pallet
      return
    end
    # if @pallet.data_agendamento.nil?
    #   flash[:danger] = "Data Agendamento can not be blank."
    #   redirect_to pallet_path(@pallet)
    #   return
    # elsif
    # if @pallet.qtde.to_i <= 0
    #   flash[:danger] = "Qtde informed must be greater than zero."
    #   redirect_to pallet_path(@pallet)
    #   return
    # end
    @drivers = Driver.order('nome')
    @carriers = Carrier.order('nome')
  end
  
  def create_os
    if params[:ordem_services][:carrier_id].blank? 
      flash[:danger] = "Carrier can not be blank."
      redirect_to driver_select_pallet_path(params[:ordem_services][:pallet_id])
      return
    elsif params[:ordem_services][:driver_id].blank? 
      flash[:danger] = "Driver can not be blank."
      redirect_to driver_select_pallet_path(params[:ordem_services][:pallet_id])
      return
    elsif params[:ordem_services][:placa].blank? 
      flash[:danger] = "Placa can not be blank."
      redirect_to driver_select_pallet_path(params[:ordem_services][:pallet_id])
      return
    end

    @pallet = Pallet.find(params[:ordem_services][:pallet_id])
    @pallet.create_os(params[:ordem_services])
    redirect_to ordem_services_path
  end

  def visit_all
    @pallets = Pallet.state_all
  end

  def visit_complete
    @pallets = Pallet.state_complete
  end

  def visit_open
    @pallets = Pallet.state_open
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pallet
      @pallet = Pallet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pallet_params
      params.require(:pallet).permit(:client_id, :billing_client_id, :carrier_id, :data_agendamento, :qtde, :data_informada, 
        :qtde_informada, :status,
        nfe_keys_attributes: [:nfe, :chave, :asset, :qtde, :remessa_ype, :peso, :volume, :id, :_destroy]
        )
    end

end
