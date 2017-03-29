class NfeXmlsController < ApplicationController
  before_filter :authenticate_user!
  #before_action :set_group_client, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource
  
  def index
    @nfe_xmls = NfeXml.order('id desc')
  end

  def new
    @nfe_xmls = NfeXml.new
  end

  # def create
  #   respond_to do |format|
  #     if @boarding = Boarding.create_ordem_service(params[:nfe_xml]) #deve retornar o id
  #       format.html { redirect_to @boarding, flash: { success: "Boarding was successfully created." } }
  #       format.json { render action: 'show', status: :created, location: @boarding }
  #     else
  #       format.html { render action: 'new' }
  #       format.json { render json: @carrier.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end


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

  private
  	def nfe_xml_params
  		params.require(:nfe_xml).permit(:asset)
  	end

end
