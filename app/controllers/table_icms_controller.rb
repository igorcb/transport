class TableIcmsController < ApplicationController
  before_action :set_table_icms, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @q = TableIcms.where(id: -1).search(params[:query])
    @table_icms = TableIcms.where(state_source: "CE")
    respond_with(@table_icms)        
  end

  def show
    respond_with(@table_icms)
  end

  def new
    @table_icms = TableIcms.new
    respond_with(@table_icms)
  end

  def edit
  end

  def create
    @table_icm = TableIcms.new(table_icms_params)
    @table_icm.save
    respond_with(@table_icm)
  end

  def update
    @table_icms.update(table_icms_params)
    respond_with(@table_icms)
  end

  def destroy
    @table_icm.destroy
    respond_with(@table_icm)
  end

  def search
    @q = TableIcms.search(params[:query])
    @table_icms = @q.result
    respond_with(@table_icms) do |format|
     format.js
    end
  end   

  private
    def set_table_icms
      @table_icms = TableIcms.find(params[:id])
    end

    def table_icms_params
      params.require(:table_icms).permit(:state_source, :state_target, :aliquot)
    end
end
