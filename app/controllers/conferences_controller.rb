class ConferencesController < ApplicationController

  def index
  end

  def create
  end

  def add_item
    conference_item = ConferenceItem.new
    conference_item.conference_id = params[:conference_id];
    conference_item.product_id = params[:product_id];
    conference_item.qtde_oper = params[:qtde_oper];
    conference_item.save

    conference = Conference.find(params[:conference_id])
    conference.finish_time = Time.now
    conference.save

    redirect_to "/input_controls/#{params[:id]}/items"
  end

end
