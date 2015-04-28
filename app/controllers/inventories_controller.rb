class InventoriesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_all
  load_and_authorize_resource
	respond_to :html, :js, :json

  def index
		@inventory = Inventory.new
  end

  def create
  	@inventory = @ordem_service.inventories.build(inventory_params)
  	#flash[:notice] = "Successfully created alias."
    if @inventory.save                               
	  	flash[:success] = "Successfully created inventory."
    else
	    @inventory.errors.full_messages.each do |msg|
  	    flash[:danger] = msg  
      end
    end

  end

  def destroy
  end

  private

    def inventory_params
      params.require(:inventory).permit(:descricao, :qtde, :estado, :valor)
    end

    def load_all
	  	@ordem_service = OrdemService.find(params[:ordem_service_id])
      @inventories = @ordem_service.inventories
    end

end
