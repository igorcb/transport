class BoardingVehiclesController < ApplicationController
  respond_to :js

  def index
    @boarding = Boarding.find(params[:boarding_id])
	end

  def create
    @boarding = Boarding.find(params[:boarding_id])
    @vehicle = Vehicle.where(placa: params[:boarding_vehicle][:vehicle_id]).first
    @result = Boardings::AddVehiclesService.new(@boarding, @vehicle).call
    @result[:success] ? flash.now[:notice] = @result[:message] : flash[:error] = @result[:message]
  end

  # def destroy
  #   @boarding = Boarding.find(params[:boarding_id])
  #   @boarding_item = BoardingItem.find(params[:id])
  #   @ordem_service = OrdemService.where(id: @boarding_item.ordem_service_id).first
  #   @result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, current_user).call
  #   if @result[:success] == true
  #     flash.now[:notice] = @result[:message]
  #   else
  #     flash[:error] = @result[:message]
  #   end
  # end

  private

    def boarding_item_params
      params.require(:boarding_vehicle).permit(:boarding_id, :vehicle_id)
    end

end
