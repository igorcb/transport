class SpecialtiesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_specialty, only: [:show, :edit, :update, :destroy]

  # GET /specialties
  # GET /specialties.json
  def index
    @specialties = Specialty.all
  end

  # GET /specialties/1
  # GET /specialties/1.json
  def show
  end

  # GET /specialties/new
  def new
    @specialty = Specialty.new
  end

  # GET /specialties/1/edit
  def edit
  end

  # POST /specialties
  # POST /specialties.json
  def create
    @specialty = Specialty.new(specialty_params)

    respond_to do |format|
      if @specialty.save
        format.html { redirect_to @specialty, flash: { success: "Specialty was successfully created." } }
        format.json { render action: 'show', status: :created, location: @specialty }
      else
        format.html { render action: 'new' }
        format.json { render json: @specialty.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /specialties/1
  # PATCH/PUT /specialties/1.json
  def update
    respond_to do |format|
      if @specialty.update(specialty_params)
        format.html { redirect_to @specialty, flash: { success: 'Specialty was successfully updated.' } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @specialty.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /specialties/1
  # DELETE /specialties/1.json
  def destroy
    @specialty.destroy
    respond_to do |format|
      format.html { redirect_to specialties_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_specialty
      @specialty = Specialty.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def specialty_params
      params.require(:specialty).permit(:descricao, :valor)
    end
end
