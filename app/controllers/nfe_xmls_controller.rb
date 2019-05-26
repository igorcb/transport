class NfeXmlsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nfe_xml, only: [ :edit, :update, :delete ]
  load_and_authorize_resource

  respond_to :html, :js

  def index
    @q = NfeXml.where(id: -1).search(params[:q])
    @nfe_xmls = NfeXml.is_not_input.order('id desc')
    respond_with(@nfe_xmls)
  end

  def show
    #code
  end


  def new
    @nfe_xmls = NfeXml.new
  end

  def edit
  end

  def create
    @nfe_xml = NfeXml.new(nfe_xml_params)
    respond_to do |format|
      #if @nfe_xml = NfeXml.create_ordem_service(params[:nfe_xml])
      if @nfe_xml.save
        format.html { redirect_to nfe_xmls_path, flash: { success: "nfe_xml was successfully created." } }
      else
        format.html { render action: 'new' }
        format.json { render json: @nfe_xml.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @nfe_xml.update(nfe_xml_params)
        #format.html { redirect_to action_inspectors_path, flash: { success: "Confirma DAE was successfully updated." } }
        format.html { redirect_to @nfe_xml, flash: { success: "NF-e XML was successfully updated." } }
      else
        format.html { render action: 'edit' }
      end
    end
  end

  def edit_qtde_pallet
    #code
  end

  def update_qtde_pallet
    if params[:nfe_xml][:qtde_pallet].blank?
      flash[:danger] = "Qtde Pallets is not present."
      redirect_to edit_qtde_pallet_nfe_xml_path(@nfe_xml)
      return
    end
    if !(params[:nfe_xml][:qtde_pallet].to_i > 0)
      flash[:danger] = "Qtde Pallets must be greater than 0 (zero)."
      redirect_to edit_qtde_pallet_nfe_xml_path(@nfe_xml)
      return
    end
    if @nfe_xml.update(nfe_xml_params)
      ordem_service = @nfe_xml.ordem_service('input_controls')
      NfeKey.where(nfe: @nfe_xml.numero, nfe_type: 'OrdemService', nfe_id: ordem_service.id).update_all(qtde_pallet: @nfe_xml.qtde_pallet) if ordem_service.present?
      flash[:success] = "NF-e information pallet was successfully "
    else
      flash[:danger] = "Error NF-e information."
    end
    redirect_to list_nfe_xmls_input_control_path(@nfe_xml.input_control)
  end

  def xml_process
    if @nfe_xml.xml_process(@nfe_xml.id)
      flash[:success] = "NF-e process was successfully "
    else
      flash[:danger] = "Error NF-e information."
    end
    redirect_to nfe_xmls_path
  end

  def search
    if params[:query][:has_input_control] == 0 #NAO
      @q = NfeXml.is_not_input.order('id desc').search(params[:query])
    else
      @q = NfeXml.order('id desc').search(params[:query])
    end
    @nfe_xmls = @q.result
    respond_with(@nfe_xmls) do |format|
     format.js
    end
  end

  def destroy
    @nfe_xml.destroy
    respond_with(@nfe_xml)
  end

  private
    def set_nfe_xml
      @nfe_xml = NfeXml.find(params[:id])
    end

  	def nfe_xml_params
  		params.require(:nfe_xml).permit(:asset, :action_inspector, :equipamento, :qtde_pallet, :place)
  	end
end
