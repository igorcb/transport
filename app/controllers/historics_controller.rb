class HistoricsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_historic, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @historics = Historic.all
    respond_with(@historics)
  end

  def show
    respond_with(@historic)
  end

  def new
    @historic = Historic.new
    respond_with(@historic)
  end

  def edit
  end

  def create
    @historic = Historic.new(historic_params)
    respond_to do |format|
      if @historic.save                               
        format.html { redirect_to @historic, flash: { success: "Historic was successfully created." } }
        format.json { render action: 'show', status: :created, location: @historic }
      else
        format.html { render action: 'new' }
        format.json { render json: @historic.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
   respond_to do |format|
      if @historic.update(historic_params) 
        format.html { redirect_to @historic, flash: { success: "Historic client was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @historic.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @historic.destroy
    respond_with(@historic)
  end

  private
    def set_historic
      @historic = Historic.find(params[:id])
    end

    def historic_params
      params.require(:historic).permit(:descricao, :tipo)
    end
end
