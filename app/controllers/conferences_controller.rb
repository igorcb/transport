class ConferencesController < ApplicationController

  def index
  end

  def create
  end

  def add_item
    Conferences::ConferenceItemCreateService.new({conference_id: params[:conference_id], product_id: params[:product_id], qtde_oper: params[:qtde_oper]}).call
    redirect_to "/input_controls/#{params[:id]}/items"
  end

  def finish_conference

  end

end
