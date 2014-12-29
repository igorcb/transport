class BudgetsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_budget, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  # GET /budgets
  # GET /budgets.json
  def index
    @budgets = Budget.order('created_at desc')
  end

  # GET /budgets/1
  # GET /budgets/1.json
  def show
  end

  # GET /budgets/new
  def new
    @budget = Budget.new
    @budget.budget_items.build
  end

  # GET /budgets/1/edit
  def edit
  end

  # POST /budgets
  # POST /budgets.json
  def create
    budget_items = params[:budget_items][:qtde]

    @budget = Budget.new(budget_params)

    respond_to do |format|
      if @budget.save
        budget_items.each do |item|
          item_quantidade = ""
          item_quantidade = item[1]
            #if !item[1].blank? or !item[1] == "0" 
          if item_quantidade.to_s == 0
            @budget.budget_items.create!(product_id: item[0], qtde: item[1] )
          end
        end
        format.html { redirect_to @budget, flash: { success: "Budget was successfully created." } }
        format.json { render action: 'show', status: :created, location: @budget }
      else
        format.html { render action: 'new' }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /budgets/1
  # PATCH/PUT /budgets/1.json
  def update
    budget_items = params[:budget_items][:qtde]
    respond_to do |format|
      if @budget.update(budget_params)
        budget_items.each do |item|

          if item[1].blank? or item[1] == "0" 
            item_budget = @budget.budget_items.find_by_product_id(item[0])
            item_budget.destroy if !item_budget.nil?
          else
            item_budget = @budget.budget_items.find_by_product_id(item[0])
            if item_budget.nil?
              @budget.budget_items.create!(product_id: item[0], qtde: item[1] ) 
            else
              item_budget.qtde = item[1]
              item_budget.save
            end
           end
        end
        format.html { redirect_to @budget, flash: { success: "Budget was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @budget.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /budgets/1
  # DELETE /budgets/1.json
  def destroy
    @budget.destroy
    respond_to do |format|
      format.html { redirect_to budgets_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_budget
      @budget = Budget.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def budget_params
      params.require(:budget).permit(:data, :email, :nome, :fone, :estado_origem, :municipio_origem, :estado_destino, :municipio_destino)
    end
end
