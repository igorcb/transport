class BreakdownsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :load_all, except: [:destroy]
  load_and_authorize_resource
	respond_to :html, :js, :json

  def index
		@breakdown = Breakdown.new
  end

  def create
    @product = Product.where(cod_prod: params[:breakdown][:product_id]).first
    if @product.nil?
      @breakdown.errors.add(:product_id, "Product not found.")
      return
    end
    
    @breakdown = @input_control.breakdowns.build(breakdown_params)
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
    @breakdown = Breakdown.find(params[:id])
    @breakdown.destroy
    respond_to :js
  end

  private

    def breakdown_params
      params.require(:breakdown).permit(:input_control_id, :nfe_xml_id, :product_id, :type_breakdown, :sobras, :faltas, :avarias)
    end

    def load_all
	  	@input_control = InputControl.find(params[:input_control_id])
      @breakdowns = @input_control.breakdowns.order('id desc')
    end
end
