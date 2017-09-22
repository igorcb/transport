class ItemOrdemServicesController < ApplicationController
  before_filter :authenticate_user!
  load_and_authorize_resource
  respond_to :html, :js, :json

  def get_product_by_nfe_keys_and_boarding
    @item_product = ItemOrdemService.joins(:product).where(number: params[:nfe_xml_id], products: {cod_prod: params[:product_id]}).first
    respond_to do |format|
      format.js
    end
  end
end