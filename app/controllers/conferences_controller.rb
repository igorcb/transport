class ConferencesController < ApplicationController

  def index
  end

  def correction

  end

  def approved_last
    input_control = InputControl.find(params[:input_control_id])
    # conference = input_control.conferences.last
    # conference.update(approved: :yes)
    Conferences::ApproveConferenceWithDivergenceService.new(input_control).call
    redirect_to review_conference_input_control_path(input_control.id)
  end

  def add_item
    @input_control = InputControl.where(id: params[:id]).first
    Conferences::ConferenceItemCreateService.new(
      {input_control_id: params[:id], product_id: params[:product_id], qtde_oper: params[:qtde_oper]}).call

    redirect_to items_input_control_path(@input_control)
  end

  def add_avaria
    input_control = InputControl.where(id: params[:id]).first
    product = Product.find(params[:product_id])

    Conferences::ConferenceItemBreakdownCreateService.new(input_control, product, params[:qtde_oper]).call

    redirect_to add_avaria_input_control_path(input_control)
  end

  def finish_conference
    @conference = Conference.where(id: params[:id])
    Conferences::ConferenceFinishService.new(@conference).call
    redirect_to oper_input_controls_path
  end

  def finish_avaria
    @input_control = InputControl.where(id: params[:id]).first
    @input_control.update(date_finish_avaria: Date.today, date_finish_avaria: Time.now)
    redirect_to oper_input_controls_path
  end

  def destroy_item
    conference_item = ConferenceItem.where(id: params[:id]).first
    input_control = InputControl.find(conference_item.conference.conference_id)

    conference_item.destroy
    redirect_to items_input_control_path(input_control)
  end

  def destroy_avaria
    breakdown = Breakdown.where(id: params[:id]).first
    input_control = InputControl.find(breakdown.breakdown_id)

    breakdown.destroy
    redirect_to add_avaria_input_control_path(input_control)
  end

end
