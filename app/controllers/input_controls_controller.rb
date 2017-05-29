class InputControlsController < ApplicationController
  before_filter :authenticate_user!
  before_action :set_input_control, only: [:show, :edit, :update, :destroy, :select_nfe]
  load_and_authorize_resource  

  respond_to :html

  def received
    if @input_control.received
      flash[:success] = "Input Control was successfully received"
    else
      flash[:success] = "Error receiving input control."
    end
    redirect_to input_control_path(@input_control)
  end

  def create_ordem_service
    if params[:nfe].blank?
      flash[:danger] = "Select at least one nfe to generate the ordem service."
      respond_with(@input_control)
      return
    end
    if !@input_control.status_received?
      flash[:danger] = "First declare that you received the products"
      respond_with(@input_control)
      return
    elsif @input_control.date_receipt.blank?
      flash[:danger] = "Receipt date can not be blank."
      respond_with(@input_control)
      return
    end
    # criar um modulo para get_hash_ids e check_client_billing
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    puts ">>>>>>>>>>>>>>>>>>>>>>> check_client_billing: #{InputControl.check_client_billing?(ids)} <<<<<<<<<<<<<<<<<<<<<<<<"
    if !InputControl.check_client_billing?(ids)
      flash[:danger] = "Customer invoices are not the same."
      respond_with(@input_control)
      return
    end
    InputControl.create_ordem_service_input_controls({id: params[:id], nfe: ids})
    puts ">>>>>>>>>>>>>ID Input Control: #{@input_control.id} "
    respond_with(@input_control)
  end

  def select_nfe
    if !@input_control.status_received?
      flash[:danger] = "First declare that you received the products"
      redirect_to (@input_control)
      return
    end
    if @input_control.date_receipt.blank?
      flash[:danger] = "Receipt date can not be blank."
      redirect_to (@input_control)
      return
    end
  end

  def create_stok_pallets
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    InputControl.create_stok_pallets({id: params[:id], nfe: ids})
    puts ">>>>>>>>>>>>>ID Input Control: #{@input_control.id} "
    respond_with(@input_control)
  end

  def select_pallets
    if @input_control.date_receipt.blank?
      flash[:danger] = "Receipt date can not be blank."
      redirect_to (@input_control)
      return
    end
  end


  def index
    @input_controls = InputControl.order(date_entry: :desc, time_entry: :desc)
    respond_with(@input_controls)
  end

  def show
    respond_with(@input_control)
  end

  def new
    @input_control = InputControl.new
    respond_with(@input_control)
  end

  def edit
  end

  def create
    # @input_control = InputControl.new(input_control_params)
    # @input_control.save
    # respond_with(@input_control)
    @input_control.user_id = current_user.id
    respond_to do |format|
      if @input_control.save                               
        format.html { redirect_to @input_control, flash: { success: "Input Control was successfully created." } }
        format.json { render action: 'show', status: :created, location: @input_control }
      else
        format.html { render action: 'new' }
        format.json { render json: @input_control.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    # @input_control.update(input_control_params)
    # respond_with(@input_control)
   respond_to do |format|
      if @input_control.update(input_control_params) 
        format.html { redirect_to @input_control, flash: { success: "Input Control client was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @input_control.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @input_control.destroy
    respond_with(@input_control)
  end

  private
    def set_input_control
      @input_control = InputControl.find(params[:id])
    end

    def input_control_params
      params.require(:input_control).permit(:carrier_id, :driver_id, :place, :place_cart, 
        :place_cart_2, :date_entry, :time_entry, :date_receipt, :palletized, :quantity_pallets, 
        :observation,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy]
        )
    end
end
