class BreakdownNfeXmlsController < ApplicationController

  def index
    @nfe_xml= NfeXml.where(id: params[:nfe_xml_id]).first
    @breakdown_nfe_xml = BreakdownNfeXml.new
  end

  def new
    @input_control = InputControl.where(id: params[:input_control_id]).first
    @nfe_xml = NfeXml.where(numero: params["nfe_xml_numero"]).first
    @breakdown_nfe_xmls = @input_control.breakdown_nfe_xmls.where(nfe_xml_id: @nfe_xml.id)

    @breakdown_nfe_xml = BreakdownNfeXml.new
  end

  def create

    input_control = InputControl.where(id: params[:input_control_id]).first
    nfe_xml = NfeXml.where(numero: breakdown_nfe_xml_params[:nfe_xml_numero]).first
    product = Product.where(cod_prod: breakdown_nfe_xml_params[:product_id]).first

    item_product = ItemInputControl.joins(:product).where(input_control_id: input_control.id, number_nfe: nfe_xml.numero, products: {cod_prod: product.cod_prod}).first

    if item_product.nil?
      flash_message({success: false, message: "Produto invalido"})
    else
      BreakdownNfeXml.create!(nfe_xml_id: nfe_xml.id, input_control_id: input_control.id, product_id: product.id, type_breakdown: breakdown_nfe_xml_params[:type_breakdown].to_i, unid_medida: breakdown_nfe_xml_params[:unid_medida], avarias: breakdown_nfe_xml_params[:avarias], sobras: breakdown_nfe_xml_params[:sobras], faltas: breakdown_nfe_xml_params[:faltas])
    end

    redirect_to new_input_control_breakdown_nfe_xml_path(input_control.id, nfe_xml_numero: nfe_xml.numero)
  end

  def update

  end

  def destroy
    breakdown_nfe_xml = BreakdownNfeXml.where(id: params[:id]).first
    input_control = InputControl.where(id: params[:input_control_id]).first

    breakdown_nfe_xml.destroy
    redirect_to new_input_control_breakdown_nfe_xml_path(input_control.id, nfe_xml_numero: params[:nfe_xml_numero])
  end

  def nfe_assoc_to_breakdown
    @input_control = InputControl.where(id:  params[:input_control_id]).first
    # ConferenceBreakdowns::NfeAssocService.new(@input_control).call

    redirect_to list_nfe_xmls_input_control_path(@input_control)
  end


  private

  def breakdown_nfe_xml_params
    params.require(:breakdown_nfe_xml).permit(:nfe_xml_id, :nfe_xml_numero, :product_id, :faltas, :sobras, :avarias, :unid_medida, :type_breakdown)
  end

end
