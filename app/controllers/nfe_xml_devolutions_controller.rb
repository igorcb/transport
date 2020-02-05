class NfeXmlDevolutionsController < ApplicationController
  # before_action :set_nfe_xml, only: [ :edit, :update, :delete ]
  # load_and_authorize_resource

  def index
    @nfe_xmls = NfeXml.devolutions
  end

  def new
    @nfe_xml = NfeXml.new
  end

  def create
    @nfe_xml = NfeXml.new(nfe_xml_params)

    respond_to do |format|
      #if @nfe_xml = NfeXml.create_ordem_service(params[:nfe_xml])
      if @nfe_xml.save
        format.html { redirect_to nfe_xml_devolutions_path, flash: { success: "nfe_xml was successfully created." } }
      else
        format.html { render action: 'new' }
        format.json { render json: @nfe_xml.errors, status: :unprocessable_entity }
      end
    end
  end

  def xml_process
    @nfe_xml = NfeXml.find(params[:id])
    if @nfe_xml.xml_process(@nfe_xml.id)
      flash[:success] = "NF-e process was successfully "
    else
      flash[:danger] = "Error NF-e information."
    end
    redirect_to nfe_xml_devolutions_path
  end

  private
    def set_nfe_xml
      @nfe_xml = NfeXml.find(params[:id])
    end

  	def nfe_xml_params
  		params.require(:nfe_xml).permit(:asset, :equipamento, :number_nfo, :chave_nfo, :devolution)
  	end
end
