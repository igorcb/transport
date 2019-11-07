class ConferencesController < ApplicationController

  def index
  end

  def show
  end

  def correction

  end

  def approved_last
    input_control = InputControl.find(params[:input_control_id])
    # conference = input_control.conferences.last
    # conference.update(approved: :yes)

    @result = Conferences::ApproveConferenceWithDivergenceService.new(input_control).call
    flash_message @result
    redirect_to review_conference_input_control_path(input_control)
  end

  def add_item
    @input_control = InputControl.where(id: params[:id]).first
    @result = Conferences::ConferenceItemCreateService.new(
      {input_control_id: params[:id], product_id: params[:product_id], qtde_oper: params[:qtde_oper]}).call
    flash_message @result
    redirect_to items_input_control_path(@input_control)
  end

  def finish_conference
    @conference = Conference.where(id: params[:id]).first
    @result_analize = InputControls::AnalizeConferenceService.new(@conference.input_control, current_user).call
    flash_message @result_analize

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
