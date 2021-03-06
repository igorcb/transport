class BoardingItemsController < ApplicationController
  respond_to :js

	def index
		@boarding = Boarding.find(params[:boarding_id])
	end

  def update_row_order
    @boarding_item = BoardingItem.find(boarding_item_params[:boarding_item_id])
    @boarding_item.row_order_position = boarding_item_params[:row_order_position]
    @boarding_item.save

    render nothing: true # this is a POST action, updates sent via AJAX, no view rendered
  end

  def update_status
    @boarding_item = BoardingItem.find(params[:boarding_item_id])
    if @boarding_item.boarding.carrier_id == Boarding.carrier_not_information
      @boarding_item.errors.add("Boarding Item", "Informe a transportadora")
      redirect_to boarding_url(@boarding_item.boarding), flash: { error: "Informe a transportadora" }
      return
    elsif @boarding_item.boarding.driver_id == Boarding.driver_not_information
      @boarding_item.errors.add("Boarding Item", "Informe o motorista")
      redirect_to boarding_url(@boarding_item.boarding), flash: { error: "Informe o motorista" }
      return
    elsif @boarding_item.boarding.value_boarding.blank? or @boarding_item.boarding.value_boarding.zero?
      @boarding_item.errors.add("Boarding Item", "Informe o valor do embarque")
      redirect_to boarding_url(@boarding_item.boarding), flash: { error: "Informe o valor do embarque" }
      return
    elsif !@boarding_item.boarding.boarding_vehicles.present?
      @boarding_item.errors.add("Boarding Item", "Informe o(s) veículos para o embarque")
      redirect_to boarding_url(@boarding_item.boarding), flash: { error: "Informe o(s) veículos para o embarque" }
      return
    end
    @boarding_item.boarding.close(@boarding_item.ordem_service_id)
    redirect_to boarding_url(@boarding_item.boarding), flash: { success: "Status update successfully..." }
  end


	def create

    # @boarding = Boarding.find(params[:boarding_id])
    #
    # @boarding_item = BoardingItem.new
    # if params[:boarding_id].blank?
    #   @boarding_item.errors.add("Boarding Item", "Embarque não pode ficar em branco")
    # elsif params[:boarding_item][:ordem_service_id].blank?
    #   @boarding_item.errors.add("Boarding Item", "Ordem de Servico não pode ficar em branco.")
    # elsif params[:boarding_item][:delivery_number].blank?
    #   @boarding_item.errors.add("Boarding Item", "Numero da Entrega não pode ficar em branco.")
    # end
    #
		# @ordem_service = OrdemService.where(id: params[:boarding_item][:ordem_service_id])
		# if @ordem_service.empty?
    # 	@boarding_item.errors.add("Boarding_Item", "Ordem de Servico não encontrada")
    # 	return
    # end
    #
    # boarding_item = @boarding.boarding_items.where(ordem_service_id: @ordem_service)
    # puts ">>>>>>>>>>>>>>>>> Ordem de Servico já cadastrada: #{boarding_item.present?} - qtde: #{boarding_item.count}"
    # if boarding_item.present?
    # 	@boarding_item.errors.add("Boarding_Item", "Ordem de Servico já cadastrada no embarque.")
    # 	return
    # end
    #
    # @ordem_service.each do |os|
    # 	if os.status != OrdemService::TipoStatus::ABERTO
    # 		@boarding_item.errors.add("Boarding_Item", "Ordem de Servico #{os.id} deve estar com status em ABERTO")
    # 		return
    # 	end
    # end

    # ActiveRecord::Base.transaction do
    #   @boarding_item = @boarding.boarding_items.create!(boarding_item_params)
    #   OrdemService.where(id: params[:boarding_item][:ordem_service_id]).update_all(status: OrdemService::TipoStatus::AGUARDANDO_EMBARQUE)
  	#   if @boarding_item.save
  	#     flash.now[:notice] = "Boarding Items created successfully."
    #   else
    #     @boarding_item.errors.full_messages.each do |msg|
    #       flash[:error] = msg
    #     end
    #   end
    # end
    #@boarding_item = BoardingItem.new
    @boarding = Boarding.find(params[:boarding_id])
    @ordem_service = OrdemService.where(id: params[:boarding_item][:ordem_service_id]).first
    @result = Boardings::AddBoardingItemService.new(@boarding, @ordem_service, current_user).call
    if @result[:success] == true
      flash.now[:notice] = @result[:message]
    else
      flash[:error] = @result[:message]
    end
  end

  def destroy
    # @boarding_item = BoardingItem.find(params[:id])
    # # unless @boarding_item.can_destroy_item?
    # #   Event.create(user: current_user, controller_name: "BoardingItem", action_name: 'destroy' , what: "Deletou a O.S. No: #{@boarding_item.ordem_service_id} do embarque No: #{@boarding_item.boarding_id}")
    # # end
    # # @ordem_service = OrdemService.where(id: @boarding_item.ordem_service_id).update_all(status: OrdemService::TipoStatus::ABERTO)
    # # @boarding_item.destroy
    # if @boarding_item.can_destroy_item?
    #   Event.create(user: current_user, controller_name: "BoardingItem", action_name: 'destroy' , what: "Deletou a O.S. No: #{@boarding_item.ordem_service_id} do embarque No: #{@boarding_item.boarding_id}")
    #   @ordem_service = OrdemService.where(id: @boarding_item.ordem_service_id).update_all(status: OrdemService::TipoStatus::ABERTO)
    #   @boarding_item.destroy
    #   flash[:success] = "BoardingItem destroyed successfully."
    # else
    #   flash[:danger] = "You can not delete record with relationship"
    #   #respond_to @boarding_item.boarding
    # end
    # respond_with(@boarding_item)
    @boarding = Boarding.find(params[:boarding_id])
    @boarding_item = BoardingItem.find(params[:id])
    @ordem_service = OrdemService.where(id: @boarding_item.ordem_service_id).first
    @result = Boardings::DeleteBoardingItemService.new(@boarding, @ordem_service, current_user).call
    if @result[:success] == true
      flash.now[:notice] = @result[:message]
    else
      flash[:error] = @result[:message]
    end
  end

  private

    def boarding_item_params
      params.require(:boarding_item).permit(:ordem_service_id, :delivery_number, :row_order_position, :boarding_item_id)
    end


end
