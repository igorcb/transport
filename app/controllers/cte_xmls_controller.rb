class CteXmlsController < ApplicationController
  def index
    @cte_xmls = CteXml.order('id desc')
  end

  def new
  	@cte_xml = CteXml.new
  end

  def create
    @cte_xml = CteXml.new(cte_xml_params)
    respond_to do |format|
      if @cte_xml.save
        format.html { redirect_to cte_xmls_path, flash: { success: "cte_xml was successfully created." } }
      else
        format.html { render action: 'new' }
        format.json { render json: @cte_xml.errors, status: :unprocessable_entity }
      end
    end
  end

  private
  	def cte_xml_params
  		params.require(:cte_xml).permit(:asset)
  	end
end
