class BreakdownInputControlsController < ApplicationController
	#before_filter :authenticate_user!
	before_filter :load_all
	#load_and_authorize_resource
	respond_to :html, :js, :json

  def index
		@breakdown = Breakdown.new
  end

  def create
    @breakdown = @input_control.breakdowns.build
    @number_nfe = params[:breakdown][:nfe_xml_id]
    @nfe_xml = NfeXml.where(nfe_type: NfeXml::TypeNfe::INPUTCONTROL, numero: @number_nfe).first
    if @nfe_xml.nil?
      @breakdown.errors.add(:nfe_xml_id, "NF-e. not found or does not belong to this input control.")
      return
    end
    @product = Product.where(cod_prod: params[:breakdown][:product_id]).first
    if @product.nil?
      @breakdown.errors.add(:product_id, "not found.")
      return
    end

    @item_input_controls = @input_control.item_input_controls.where(number_nfe: @number_nfe, product_id: @product.id).first
    if @item_input_controls.nil?
      @breakdown.errors.add(:product_id, "not found or does not belong to this input control and NF-e.")
      return
    end
    
    @breakdown = @input_control.breakdowns.build(breakdown_params)
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
    @breakdown = @input_control.breakdowns.find(params[:id])
    @breakdown.destroy
    respond_to :js
  end

  private

    def breakdown_params
      params.require(:breakdown).permit(:nfe_xml_id, :product_id, :type_breakdown, :sobras, :faltas, :avarias)
    end

    def load_all
		 	@input_control = InputControl.find(params[:input_control_id])
      @breakdowns = @input_control.breakdowns.order('id desc')
    end

end
