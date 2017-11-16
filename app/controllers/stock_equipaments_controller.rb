class StockEquipamentsController < ApplicationController
  def index
  	@q = ControlPalletInternal.all_equipament.where(id: -1).search(params[:q])
  end

  def search
    @q = ControlPalletInternal.all_equipament.search(params[:query])
    @input_controls = @q.result
    respond_with(@input_controls) do |format|
      format.js
    end
  end
end
