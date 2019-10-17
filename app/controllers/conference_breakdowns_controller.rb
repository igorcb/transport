class ConferenceBreakdownsController < ApplicationController
  def create
    input_control = InputControl.where(id: params[:input_control_id]).first
    product = Product.find(params[:product_id])

    # result = ConferenceBreakdowns::CreateService.new(input_control, product, driver_params[:qtde_oper], driver_params[:image]).call

    render html: helpers.tag.strong(driver_params.inspect)
    # flash_message result

    # redirect_to add_avaria_input_control_path(input_control)
  end


  def destroy
    conference_breakdown = ConferenceBreakdown.where(id: params[:id]).first

    input_control = conference_breakdown.conference.input_control
    conference_breakdown.destroy
    redirect_to add_avaria_input_control_path(input_control)

  end

  def finish
    @input_control = InputControl.where(id: params[:id]).first
    ConferenceBreakdowns::FinishService.new(@input_control).call

    redirect_to oper_input_controls_path
  end


  def driver_params
    params.permit(:qtde_oper, asset: [:asset, :id, :_destroy])
  end


end
