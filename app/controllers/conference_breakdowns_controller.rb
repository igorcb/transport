class ConferenceBreakdownsController < ApplicationController
  before_action :set_conference_breakdown, only: [:show, :edit, :update, :destroy]

  # GET /conference_breakdowns
  # GET /conference_breakdowns.json
  def index
    @input_control = InputControl.where(id: params[:input_control_id]).first
    @conference = @input_control.conferences.where(id: params[:conference_id]).first
    @conference_breakdowns = @conference.conference_breakdowns
    @conference_breakdown = ConferenceBreakdown.new

    @request_items = input_control_conference_conference_breakdowns_path(@input_control, @conference)
    @ean = params["ean"] == """" ? nil : params["ean"]
    # @breakdown = @input_control.conferences.last.conference_breakdowns

    if @ean.present?
      @product = Product.where("cod_prod = ? or ean_box = ?", params["ean"], params["ean"]).first
    end
  end

  # GET /conference_breakdowns/1
  # GET /conference_breakdowns/1.json
  def show
  end

  # GET /conference_breakdowns/new
  def new
    @conference_breakdown = ConferenceBreakdown.new
  end

  # GET /conference_breakdowns/1/edit
  def edit
  end

  # POST /conference_breakdowns
  # POST /conference_breakdowns.json
  def create
    @input_control = InputControl.where(id: params[:input_control_id]).first
    @conference = @input_control.conferences.where(id: params[:conference_id]).first

    item_conference_breakdown = params[:conference_breakdown]
    qtde = item_conference_breakdown["qtde"]
    product_id = conference_breakdown_params[:product_id]
    @item_conference_breakdown = @conference.conference_breakdowns.where(product_id: product_id).first

    item_conference_breakdown["qtde"] = @item_conference_breakdown.present? ? qtde.to_i + @item_conference_breakdown.qtde.to_i : qtde

    respond_to do |format|
      if @conference_breakdown = ConferenceBreakdown.where(conference_id: @conference.id, product_id: params[:conference_breakdown][:product_id]).update_or_create(item_conference_breakdown)
        format.html { redirect_to input_control_conference_conference_breakdowns_path(@input_control, @conference), notice: 'Conference breakdown was successfully created.' }
        format.json { render :show, status: :created, location: @conference_breakdown }
      else
        format.html { render :new }
        format.json { render json: @conference_breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /conference_breakdowns/1
  # PATCH/PUT /conference_breakdowns/1.json
  def update
    respond_to do |format|
      if @conference_breakdown.update(conference_breakdown_params)
        format.html { redirect_to @conference_breakdown, notice: 'Conference breakdown was successfully updated.' }
        format.json { render :show, status: :ok, location: @conference_breakdown }
      else
        format.html { render :edit }
        format.json { render json: @conference_breakdown.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /conference_breakdowns/1
  # DELETE /conference_breakdowns/1.json
  def destroy
    conference = @conference_breakdown.conference
    input_control = conference.input_control

    @conference_breakdown.destroy
    respond_to do |format|
      format.html { redirect_to input_control_conference_conference_breakdowns_path(input_control, conference), notice: 'Conference breakdown was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def finish
    @input_control = InputControl.where(id: params[:id]).first
    @result = ConferenceBreakdowns::FinishService.new(@input_control).call
    flash_message(@result)
    @result_2 = ConferenceBreakdowns::NfeAssocService.new(@input_control).call
    flash_message(@result_2)
    redirect_to oper_input_controls_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_conference_breakdown
      @conference_breakdown = ConferenceBreakdown.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def conference_breakdown_params
      params.require(:conference_breakdown).permit(:qtde, :product_id,
        assets_attributes: [:asset, :id, :_destroy]
      )
    end
end
