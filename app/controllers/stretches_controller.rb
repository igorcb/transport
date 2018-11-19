class StretchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stretch, only: [:show, :edit, :update, :destroy]
  load_and_authorize_resource

  respond_to :html

  def index
    @stretches = Stretch.order(:estado)
  end

  def show
  end

  def new
    @stretch = Stretch.new
    respond_with(@stretch)
  end

  def edit
  end

  def create
    @stretch = Stretch.new(stretch_params)
    respond_to do |format|
      if @stretch.save
        format.html { redirect_to @stretch, flash: { success: "Stretch was successfully created." } }
        format.json { render action: 'show', status: :created, location: @stretch }
      else
        format.html { render action: 'new' }
        format.json { render json: @stretch.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stretch.update(stretch_params)
        format.html { redirect_to @stretch, flash: { success: "Stretch was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @stretch.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
  end

  private
    def set_stretch
      @stretch = Stretch.find(params[:id])
    end

    def stretch_params
      params.require(:stretch).permit(:cidade, :estado, :destino)
    end    
end
