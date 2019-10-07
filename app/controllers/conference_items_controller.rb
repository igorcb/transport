class ConferenceItemsController < ApplicationController

  def edit
    @input_control = InputControl.find(params[:input_control_id])
    # @conference = Conference.find(params[:conference_id])
    @conference_item = ConferenceItem.find(params[:id])
    @product = Product.find(@conference_item.product_id)

  end

  def update
    conference_item = ConferenceItem.find(params[:id])
    conference_item.update(qtde_oper: params[:qtde_oper])

    redirect_to review_conference_input_control_path(params[:input_control_id])
  end
end
