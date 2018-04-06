class SubCostCenterThreesController < ApplicationController
  before_filter :authenticate_user! 
  before_action :set_sub_cost_center_three, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @sub_cost_center_threes = SubCostCenterThree.all
    respond_with(@sub_cost_center_threes)
  end

  def show
    respond_with(@sub_cost_center_three)
  end

  def new
    @sub_cost_center_three = SubCostCenterThree.new
    respond_with(@sub_cost_center_three)
  end

  def edit
  end

  def create
    @sub_cost_center_three = SubCostCenterThree.new(sub_cost_center_three_params)
    respond_to do |format|
      if @sub_cost_center_three.save
        format.html { redirect_to @sub_cost_center_three, flash: { success: "SubCostCenterThree was successfully created." } }
        format.json { render action: 'show', status: :created, location: @sub_cost_center_three }
      else
        format.html { render action: 'new' }
        format.json { render json: @sub_cost_center_three.errors, status: :unprocessable_entity }
      end
    end    
  end

  def update
    respond_to do |format|
      if @sub_cost_center_three.update(sub_cost_center_three_params)
        format.html { redirect_to @sub_cost_center_three, flash: { success: "SubCostCenterThree was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @sub_cost_center_three.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sub_cost_center_three.destroy
    respond_with(@sub_cost_center_three)
  end

  private
    def set_sub_cost_center_three
      @sub_cost_center_three = SubCostCenterThree.find(params[:id])
    end

    def sub_cost_center_three_params
      params.require(:sub_cost_center_three).permit(:cost_center_id, :sub_cost_center_id, :descricao)
    end
end
