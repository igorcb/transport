class NatureFreightsController < ApplicationController
  before_action :set_nature_freight, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @nature_freights = NatureFreight.all
    respond_with(@nature_freights)
  end

  def show
    respond_with(@nature_freight)
  end

  def new
    @nature_freight = NatureFreight.new
    respond_with(@nature_freight)
  end

  def edit
  end

  def create
    @nature_freight = NatureFreight.new(nature_freight_params)
    respond_to do |format|
      if @nature_freight.save
        format.html { redirect_to @nature_freight, flash: { success: "Nature Freight was successfully created." } }
        format.json { render action: 'show', status: :created, location: @nature_freight }
      else
        format.html { render action: 'new' }
        format.json { render json: @nature_freight.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @nature_freight.update(nature_freight_params)
        format.html { redirect_to @nature_freight, flash: { success: 'Nature Freight was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @nature_freight.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @nature_freight.destroy
    respond_with(@nature_freight)
  end

  private
    def set_nature_freight
      @nature_freight = NatureFreight.find(params[:id])
    end

    def nature_freight_params
      params.require(:nature_freight).permit(:name)
    end
end
