class PalletsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_pallet, only: [:show, :edit, :update, :destroy]

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
    @pallet = Pallet.new(pallet_params)

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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pallet
      @pallet = Pallet.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def pallet_params
      params.require(:pallet).permit(:client_id, :data_agendamento, :qtde, :status)
    end
end
