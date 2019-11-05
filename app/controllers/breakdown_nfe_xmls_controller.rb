class BreakdownNfeXmlsController < ApplicationController

  def index
    @nfe_xml= NfeXml.where(id: params[:nfe_xml_id]).first
    @breakdown_nfe_xml = BreakdownNfeXml.new
  end

  def new
    @input_control = InputControl.where(id: params[:input_control_id]).first
    @breakdown_nfe_xmls = @input_control.breakdown_nfe_xmls
    @breakdown_nfe_xml = BreakdownNfeXml.new
  end

  def create

    input_control = InputControl.where(id: params[:input_control_id]).first
    nfe_xml = NfeXml.where(numero: breakdown_nfe_xml_params[:nfe_xml_id]).first
    product = Product.where(cod_prod: breakdown_nfe_xml_params[:product_id]).first

    breakdown_nfe_xml = BreakdownNfeXml.where(nfe_xml_id: nfe_xml.id, input_control_id: input_control.id, product_id: product.id)

    if breakdown_nfe_xml.nil?
      BreakdownNfeXml.create!(nfe_xml_id: nfe_xml.id, input_control_id: input_control.id, product_id: product.id, type_breakdown: breakdown_nfe_xml_params[:type_breakdown].to_i, unid_medida: breakdown_nfe_xml_params[:unid_medida], avarias: breakdown_nfe_xml_params[:avarias], sobras: breakdown_nfe_xml_params[:sobras], faltas: breakdown_nfe_xml_params[:faltas])
    else
      breakdown_nfe_xml.update(type_breakdown: breakdown_nfe_xml_params[:type_breakdown].to_i, unid_medida: breakdown_nfe_xml_params[:unid_medida], avarias: breakdown_nfe_xml_params[:avarias], sobras: breakdown_nfe_xml_params[:sobras], faltas: breakdown_nfe_xml_params[:faltas])
    end
    # puts breakdown_nfe_xml_params.inspect
    redirect_to new_input_control_breakdown_nfe_xml_path(input_control.id)
  end

  def update

  end

  def nfe_assoc_to_breakdown
    @input_control = InputControl.where(id:  params[:input_control_id]).first
    # ConferenceBreakdowns::NfeAssocService.new(@input_control).call

    redirect_to list_nfe_xmls_input_control_path(@input_control)
  end


  private

  def breakdown_nfe_xml_params
    params.require(:breakdown_nfe_xml).permit(:nfe_xml_id, :product_id, :faltas, :sobras, :avarias, :unid_medida, :type_breakdown)
  end

end
