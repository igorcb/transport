class SubCostCenterThreesController < ApplicationController
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
    @sub_cost_center_three.save
    respond_with(@sub_cost_center_three)
  end

  def update
    @sub_cost_center_three.update(sub_cost_center_three_params)
    respond_with(@sub_cost_center_three)
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
