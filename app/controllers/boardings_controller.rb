class BoardingsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_boarding, only: [:show, :edit, :update, :destroy, :lower]
  load_and_authorize_resource
  respond_to :js, :html, :json

	def selection_shipment
		@ordem_services = OrdemService.where(status: OrdemService::TipoStatus::ABERTO)
	end

	def search_ordem_service
		@ordem_service = OrdemService.find(params[:boarding_items][:ordem_service_id])
    respond_with(@ordem_service) do |format|
      format.js
    end
	end

  def index
    @boardings = Boarding.order(id: :desc)
  end

	def show

	end

	def new

	end

	def edit

	end

	def create
    respond_to do |format|
      if @boarding = Boarding.generate_shipping(params[:os][:ids]) #deve retornar o id
        format.html { redirect_to @boarding, flash: { success: "Boarding was successfully created." } }
        format.json { render action: 'show', status: :created, location: @boarding }
      else
        format.html { render action: 'new' }
        format.json { render json: @carrier.errors, status: :unprocessable_entity }
      end
    end
	end

	def update
    respond_to do |format|
      if @boarding.update(boarding_params)
        format.html { redirect_to @boarding, flash: { success: "Boarding was successfully updated." }  }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @boarding.errors, status: :unprocessable_entity }
      end
    end
	end

	def destroy
    @boarding.destroy
    respond_to do |format|
      format.html { redirect_to boardings_url }
      format.json { head :no_content }
    end
  end

	private

		def set_boarding
			@boarding = Boarding.find(params[:id])	
      @boarding_items = @boarding.boarding_items.order(:row_order) if @boarding.boarding_items.present?
      @boarding_item = BoardingItem.new
		end

    def boarding_params
      params.require(:boarding).permit(:date_boarding, :driver_id, :carrier_id, :value_boarding, :obs,
        board_items_attributes: [:delivery_number, :ordem_service_id, :id, :_destroy],
        boarding_vehicles_attributes: [:boarding_vehicles_id, :vehicle_id, :id, :_destroy]

      	)
    end

end
