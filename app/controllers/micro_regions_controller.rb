class MicroRegionsController < ApplicationController
  before_action :set_micro_region, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @micro_regions = MicroRegion.all
    respond_with(@micro_regions)
  end

  def show
    respond_with(@micro_region)
  end

  def new
    @micro_region = MicroRegion.new
    respond_with(@micro_region)
  end

  def edit
  end

  def create
    @micro_region = MicroRegion.new(micro_region_params)
    @micro_region.save
    respond_with(@micro_region)
  end

  def update
    @micro_region.update(micro_region_params)
    respond_with(@micro_region)
  end

  def destroy
    @micro_region.destroy
    respond_with(@micro_region)
  end

  private
    def set_micro_region
      @micro_region = MicroRegion.find(params[:id])
    end

    def micro_region_params
      params.require(:micro_region).permit(:name)
    end
end
