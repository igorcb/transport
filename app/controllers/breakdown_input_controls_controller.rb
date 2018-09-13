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

  def update
    @breakdown = Breakdown.find(params[:breakdown_id])
    respond_to do |format|
      if @breakdown.update(breakdown_params)
        format.html { redirect_to input_control_breakdown_input_controls_path(@input_control), flash: { success: "Breakdowns was successfully updated." }  }
        # input_control_breakdown_input_controls_path(@input_control)
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @boarding.errors, status: :unprocessable_entity }
      end
    end
  end

  def product
    #"input_control_id"=>"443", "breakdown_input_control_id"=>"59"
    @breakdown = Breakdown.where(id: params[:breakdown_input_control_id]).first
  end

  def destroy
    @breakdown = @input_control.breakdowns.find(params[:id])

    Event.create(user: current_user, controller_name: "BreakdownInputControls", action_name: 'destroy' , what: "Deletou a Avaria N.F. No: #{@breakdown.nfe_xml.numero} da Remessa de Entrada No: #{@breakdown.breakdown_id}")
    
    @breakdown.destroy
    respond_to :js
  end

  private

    def breakdown_params
      params.require(:breakdown).permit(:nfe_xml_id, :product_id, :type_breakdown, :unid_medida, 
        :sobras, :faltas, :avarias, :price, :ipi_tax, :ipi_value, :icms_tax, :icms_value,
        assets_attributes: [:asset, :id, :_destroy]
        )
    end

    def load_all
		 	@input_control = InputControl.find(params[:input_control_id])
      #@breakdowns = @input_control.breakdowns.order('id desc')
      @breakdowns = Breakdown.joins(:nfe_xml).where(breakdown_type: "InputControl", breakdown_id: @input_control.id).order('breakdowns.type_breakdown', 'nfe_xmls.numero')
    end

end
