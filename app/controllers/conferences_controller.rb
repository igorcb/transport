class ConferencesController < ApplicationController

  def index
  end

  def create
  end

  def add_item
    @input_control = InputControl.where(id: params[:id])
    Conferences::ConferenceItemCreateService.new(
      {input_control_id: params[:id], product_id: params[:product_id], qtde_oper: params[:qtde_oper]}).call

    redirect_to item_input_controls(@input_control)
  end

  def finish_conference

  end

end
