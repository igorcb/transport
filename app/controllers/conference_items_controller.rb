class ConferenceItemsController < ApplicationController

  def edit
    @input_control = InputControl.find(params[:input_control_id])
    @conference = @input_control.conferences.last
    @conference_item = ConferenceItem.where(conference_id: @conference, product_id: params[:id]).first
    @product = Product.find(params[:id])
  end

  def update
    @input_control = InputControl.find(params[:input_control_id])
    @conference = @input_control.conferences.last
    @conference_item = ConferenceItem.where(conference_id: @conference, product_id: params[:id]).first
    @conference_item.update_attributes(qtde_oper: params[:qtde_oper], qtde_sup: params[:qtde_oper])

    redirect_to review_conference_input_control_path(params[:input_control_id])
  end
end
