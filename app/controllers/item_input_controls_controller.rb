class ItemInputControlsController < ApplicationController
  before_action :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js, :json

  def get_nfe_xmls
    @item_product = ItemInputControl.where(input_control_id: params[:input_control_id], number_nfe: params[:nfe_xml_id]).first
    respond_to do |format|
      format.js
    end
  end

  def get_product_by_nfe_xmls_and_product
    @item_product = ItemInputControl.joins(:product).where(input_control_id: params[:input_control_id], number_nfe: params[:nfe_xml_id], products: {cod_prod: params[:product_id]}).first
    respond_to do |format|
      format.js
    end
  end

end