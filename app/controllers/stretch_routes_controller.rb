class StretchRoutesController < ApplicationController
  before_action :set_stretch_route, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @stretch_routes = StretchRoute.all
    respond_with(@stretch_routes)
  end

  def show
    respond_with(@stretch_route)
  end

  def new
    @stretch_route = StretchRoute.new
    respond_with(@stretch_route)
  end

  def edit
  end

  def create
    @stretch_route = StretchRoute.new(stretch_route_params)
    @stretch_route.save
    respond_with(@stretch_route)
  end

  def update
    @stretch_route.update(stretch_route_params)
    respond_with(@stretch_route)
  end

  def destroy
    @stretch_route.destroy
    respond_with(@stretch_route)
  end

  private
    def set_stretch_route
      @stretch_route = StretchRoute.find(params[:id])
    end

    def stretch_route_params
      params.require(:stretch_route).permit(:stretch_source_id, :stretch_target_id, :tax_rate, :non_tax_rate, :secure_rate, :secure_rate_filch, :secure_rate_aggravated, :travel_time, :distance, :cost_kg, :tax_iss)
    end
end