class InventoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :load_all
  load_and_authorize_resource
	respond_to :html, :js, :json

  def index
		@inventory = Inventory.new
  end

  def create
  	@inventory = @ordem_service.inventories.build(inventory_params)
  	#flash[:notice] = "Successfully created alias."
    if @inventory.save                               
	  	#flash[:success] = "Successfully created inventory."
    else
	    @inventory.errors.full_messages.each do |msg|
  	    flash[:danger] = msg  
      end
    end

  end

  def destroy
    @inventory = @ordem_service.inventories.find(params[:id])
    @inventory.destroy
    respond_to :js
  end

  private

    def inventory_params
      params.require(:inventory).permit(:numero, :descricao, :qtde, :estado, :valor)
    end

    def load_all
	  	@ordem_service = OrdemService.find(params[:ordem_service_id])
      @inventories = @ordem_service.inventories.order('id desc')
    end

end
