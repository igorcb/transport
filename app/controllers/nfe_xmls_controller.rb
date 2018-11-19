class NfeXmlsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_nfe_xml, only: [ :edit, :update ]
  load_and_authorize_resource
  
  def index
    @nfe_xmls = NfeXml.order('id desc')
  end

  def new
    @nfe_xmls = NfeXml.new
  end

  def edit
  end

  def create
    @nfe_xml = NfeXml.new(nfe_xml_params)
    respond_to do |format|
      if @nfe_xml = NfeXml.create_ordem_service(params[:nfe_xml])
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
        format.html { redirect_to action_inspectors_path, flash: { success: "Confirma DAE was successfully updated." } }
      else
        format.html { render action: 'edit' }
      end
    end   
  end  

  private
    def set_nfe_xml
      @nfe_xml = NfeXml.find(params[:id])
    end

  	def nfe_xml_params
  		params.require(:nfe_xml).permit(:asset, :action_inspector)
  	end
end
