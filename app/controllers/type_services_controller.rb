class TypeServicesController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_type_service, only: [:show, :edit, :update, :destroy]

  # GET /type_services
  # GET /type_services.json
  def index
    @type_services = TypeService.all
  end

  # GET /type_services/1
  # GET /type_services/1.json
  def show
  end

  # GET /type_services/new
  def new
    @type_service = TypeService.new
  end

  # GET /type_services/1/edit
  def edit
  end

  # POST /type_services
  # POST /type_services.json
  def create
    @type_service = TypeService.new(type_service_params)

    respond_to do |format|
      if @type_service.save
        format.html { redirect_to @type_service, flash: { success: "Type service was successfully created." } }
        format.json { render action: 'show', status: :created, location: @type_service }
      else
        format.html { render action: 'new' }
        format.json { render json: @type_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /type_services/1
  # PATCH/PUT /type_services/1.json
  def update
    respond_to do |format|
      if @type_service.update(type_service_params)
        format.html { redirect_to @type_service, flash: { success: "Type service was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @type_service.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /type_services/1
  # DELETE /type_services/1.json
  def destroy
    if @type_service.destroy
      respond_to do |format|
        format.html { redirect_to type_services_url }
        format.json { head :no_content }
      end
    else
      flash[:danger] = "The deletion failed because: " + @type_service.errors.full_messages.to_sentence
      redirect_to type_services_url
    end      
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_type_service
      @type_service = TypeService.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def type_service_params
      params.require(:type_service).permit(:descricao, :tipo)
    end
end
