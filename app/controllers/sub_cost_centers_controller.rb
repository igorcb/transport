class SubCostCentersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_sub_cost_center, only: [:show, :edit, :update, :destroy]
  #load_and_authorize_resource

  respond_to :html

  def index
    @sub_cost_centers = SubCostCenter.all
    respond_with(@sub_cost_centers)
  end

  def show
    respond_with(@sub_cost_center)
  end

  def new
    @sub_cost_center = SubCostCenter.new
    respond_with(@sub_cost_center)
  end

  def edit
  end

  def create
    @sub_cost_center = SubCostCenter.new(sub_cost_center_params)
    respond_to do |format|
      if @sub_cost_center.save
        format.html { redirect_to @sub_cost_center, flash: { success: "SubCostCenter was successfully created." } }
        format.json { render action: 'show', status: :created, location: @sub_cost_center }
      else
        format.html { render action: 'new' }
        format.json { render json: @sub_cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sub_cost_center.update(sub_cost_center_params)
        format.html { redirect_to @sub_cost_center, flash: { success: "SubCostCenter was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sub_cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    if @sub_cost_center.destroy
      respond_with(@sub_cost_center)
    else
      flash[:danger] = "The deletion failed because: " + @sub_cost_center.errors.full_messages.to_sentence
      redirect_to sub_cost_centers_url
    end      
  end

  private
    def set_sub_cost_center
      @sub_cost_center = SubCostCenter.find(params[:id])
    end

    def sub_cost_center_params
      params.require(:sub_cost_center).permit(:cost_center_id, :descricao, :type_service_id)
    end
end
