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
    @boarding_item.boarding.close(@boarding_item.ordem_service_id)
    redirect_to boarding_url(@boarding_item.boarding), flash: { success: "Status update successfully..." }
  end


	def create
		
    @boarding = Boarding.find(params[:boarding_id])

    @boarding_item = BoardingItem.new
    if params[:boarding_id].blank?
      @boarding_item.errors.add("Boarding Item", "Embarque não pode ficar em branco") 
    elsif params[:boarding_item][:ordem_service_id].blank?
      @boarding_item.errors.add("Boarding Item", "Ordem de Servico não pode ficar em branco.") 
    elsif params[:boarding_item][:delivery_number].blank?
      @boarding_item.errors.add("Boarding Item", "Numero da Entrega não pode ficar em branco.")
    end

		@ordem_service = OrdemService.where(id: params[:boarding_item][:ordem_service_id])
		if @ordem_service.empty?
    	@boarding_item.errors.add("Boarding_Item", "Ordem de Servico não encontrada")
    	return
    end

    boarding_item = @boarding.boarding_items.where(ordem_service_id: @ordem_service)
    puts ">>>>>>>>>>>>>>>>> Ordem de Servico já cadastrada: #{boarding_item.present?} - qtde: #{boarding_item.count}"
    if boarding_item.present?
    	@boarding_item.errors.add("Boarding_Item", "Ordem de Servico já cadastrada no embarque.")
    	return
    end

    @ordem_service.each do |os|
    	if os.status != OrdemService::TipoStatus::ABERTO
    		@boarding_item.errors.add("Boarding_Item", "Ordem de Servico #{os.id} deve estar com status em ABERTO")
    		return
    	end
    end

    ActiveRecord::Base.transaction do
      @boarding_item = @boarding.boarding_items.create!(boarding_item_params)
      OrdemService.where(id: params[:boarding_item][:ordem_service_id]).update_all(status: OrdemService::TipoStatus::EMBARCANDO)
  	  if @boarding_item.save
  	    flash.now[:notice] = "Boarding Items created successfully."
      else
        @boarding_item.errors.full_messages.each do |msg|
          flash[:error] = msg  
        end
      end
    end
  end

  def destroy
    @boarding_item = BoardingItem.find(params[:id])
    @ordem_service = OrdemService.where(id: @boarding_item.ordem_service_id).update_all(status: OrdemService::TipoStatus::ABERTO)
    @boarding_item.destroy
    flash[:success] = "BoardingItem destroyed successfully."
    respond_with(@boarding_item)
  end

  
  private

    def boarding_item_params
      params.require(:boarding_item).permit(:ordem_service_id, :delivery_number, :row_order_position, :boarding_item_id)
    end


end
