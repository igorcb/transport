class BreakdownBoardingsController < ApplicationController
	#before_filter :authenticate_user!
	before_filter :load_all
	#load_and_authorize_resource
	respond_to :html, :js, :json

  def index
		@breakdown = Breakdown.new
  end

  def create
    @breakdown = @boarding.breakdowns.build
    @number_nfe = params[:breakdown][:nfe_xml_id]
    @item_ordem_services = @boarding.ordem_services.joins(:item_ordem_services).where(item_ordem_services: {number: @number_nfe})
    if @item_ordem_services.nil?
      @breakdown.errors.add(:nfe_xml_id, "NF-e. not found or does not belong to this boarding.")
      return
    end

    @product = Product.where(cod_prod: params[:breakdown][:product_id]).first
    if @product.nil?
      @breakdown.errors.add(:product_id, "not found.")
      return
    end
    @item_ordem_services = nil
    @item_ordem_services = @boarding.ordem_services.joins(:item_ordem_services).where(item_ordem_services: {number: @number_nfe, product_id: @product.id})
    puts ">>>>>>>>>>>>>>>> ItemOrdemService: #{@item_ordem_services.nil?}"
    if @item_ordem_services.count == 0
      @breakdown.errors.add(:product_id, "not found or does not belong to this boarding and NF-e.")
      return
    end
    
    @breakdown = @boarding.breakdowns.build(breakdown_params)
    @breakdown.nfe_xml_id = @nfe_xml.id if @nfe_xml.present?
    @breakdown.product_id = @product.id if @product.present?
    if @breakdown.save
	  	#flash[:success] = "Successfully created breakdown."
    else
	    @breakdown.errors.full_messages.each do |msg|
  	    flash[:danger] = msg  
      end
    end

  end

  def destroy
    @breakdown = @boarding.breakdowns.find(params[:id])
    @breakdown.destroy
    respond_to :js
  end

  private

    def breakdown_params
      params.require(:breakdown).permit(:nfe_xml_id, :product_id, :type_breakdown, :sobras, :faltas, :avarias)
    end

    def load_all
		 	@boarding = Boarding.find(params[:boarding_id])
      @breakdowns = @boarding.breakdowns.order('id desc')
    end
end
