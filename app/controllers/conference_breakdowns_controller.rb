class ConferenceBreakdownsController < ApplicationController
  def create
    input_control = InputControl.where(id: params[:input_control_id]).first
    product = Product.find(params[:product_id])

    result = Conferences::ConferenceBreakdownCreateService.new(input_control, product, params[:qtde_oper]).call

    flash_message result

    redirect_to add_avaria_input_control_path(input_control)
  end


  def destroy
    conference_breakdown = ConferenceBreakdown.where(id: params[:id]).first

    input_control = conference_breakdown.conference.input_control
    conference_breakdown.destroy
    redirect_to add_avaria_input_control_path(input_control)

  end


end
