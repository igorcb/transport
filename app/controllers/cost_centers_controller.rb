class CostCentersController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_cost_center, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @cost_centers = CostCenter.all
    respond_with(@cost_centers)
  end

  def show
    respond_with(@cost_center)
  end

  def new
    @cost_center = CostCenter.new
    respond_with(@cost_center)
  end

  def edit
  end

  def create
    @cost_center = CostCenter.new(cost_center_params)
    respond_to do |format|
      if @cost_center.save
        format.html { redirect_to @cost_center, flash: { success: "CostCenter was successfully created." } }
        format.json { render action: 'show', status: :created, location: @cost_center }
      else
        format.html { render action: 'new' }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @cost_center.update(cost_center_params)
        format.html { redirect_to @cost_center, flash: { success: "CostCenter was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @cost_center.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    #@cost_center.destroy
    #respond_with(@cost_center)
    if @cost_center.destroy
      respond_with(@cost_center)
    else
      flash[:danger] = "The deletion failed because: " + @cost_center.errors.full_messages.to_sentence
      redirect_to cost_centers_url
    end
  end

  private
    def set_cost_center
      @cost_center = CostCenter.find(params[:id])
    end

    def cost_center_params
      params.require(:cost_center).permit(:descricao)
    end
end
