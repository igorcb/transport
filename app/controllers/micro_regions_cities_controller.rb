class MicroRegionsCitiesController < ApplicationController
	def new
		@micro_region = MicroRegion.find(params[:micro_region_id])
  end

  def create
  	@micro_region = MicroRegion.find(params[:micro_region_id])
  	@micro_regions_city = @micro_region.micro_regions_cities.build(params_micro_regions_cities)
    respond_to do |format|
      if @micro_regions_city.save
        format.html { redirect_to micro_region_path(@micro_region), flash: { success: "City add Micro Regions was successfully created." } }
        format.json { render action: 'show', status: :created, location: @micro_regions_city }
      else
        format.html { render action: 'new' }
        format.json { render json: @micro_regions_city.errors, status: :unprocessable_entity }
      end  	
    end
  end

  private
  	def params_micro_regions_cities
  		params.require(:micro_regions_city).permit(:city_id)
  	end
end