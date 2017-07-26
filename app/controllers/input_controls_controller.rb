class InputControlsController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  before_filter :authenticate_user!
  before_action :set_input_control, only: [:show, :edit, :update, :destroy, :select_nfe]
  load_and_authorize_resource  

  respond_to :html, :js

  def quitter
    #respond_with(@input_control)
    respond_to do |format|
      format.html
      # Example: Basic Usage
      format.pdf { render_quitter_input_control(@input_control) }
    end
  end

  def finish_typing
    if @input_control.finish_typing
      #@input_control.update_attributes(received_user_id: current_user.id)
      flash[:success] = "Input Control was successfully received"
    else
      flash[:success] = "Error receiving input control."
    end
    redirect_to input_control_path(@input_control)
  end

  def received
  end

  def confirm_received
    if @input_control.received
      @input_control.update_attributes(received_user_id: current_user.id)
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
    #@input_controls = InputControl.order(date_entry: :desc, time_entry: :desc)
    #@q = Boarding.where(status: -1).search(params[:q])
    @q = InputControl.where(status: -1).search(params[:q])
    @input_controls = InputControl.includes(:carrier, :driver).order(date_entry: :desc, time_entry: :desc)
    respond_with(@input_controls)
  end

  def search
    @q = InputControl.includes(:carrier, :driver).order(date_entry: :desc, time_entry: :desc).search(params[:query])
    @input_controls = @q.result
    respond_with(@input_controls) do |format|
      format.js
    end
  end

  def show
    @cancellation = @input_control.cancellations.build
    #respond_with(@input_control)
    respond_to do |format|
      format.html # index.html.erb
      # Example: Basic Usage
      format.pdf { render_input_control(@input_control) }
    end
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
    driver  = Driver.find_by_cpf(params[:driver_cpf])
    carrier = Carrier.find_by_cnpj(params[:carrier_cnpj])
    @input_control.driver_id = driver.id
    @input_control.carrier_id = carrier.id
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

  def comments
    @comment = Comment.new
  end

  def received_weight_search
    @input_controls = InputControl.where("date_receipt >= ? and date_receipt <= ?", params[:start_date], params[:end_date])
                                  .select_date_receipt
    @input_control_total = InputControl.where("date_receipt >= ? and date_receipt <= ?", params[:start_date], params[:end_date])
                                  .select_date_receipt_total
    respond_with(@input_controls) do |format|
      format.js
    end
  end

  def received_weight
    @input_controls = InputControl.select_date_receipt
    @input_control_total = InputControl.select_date_receipt_total
    respond_with(@input_controls)
  end

  private
    def set_input_control
      @input_control = InputControl.find(params[:id])
    end

    def input_control_params
      params.require(:input_control).permit(:carrier_id, :driver_id, :place, :place_cart, 
        :place_cart_2, :date_entry, :time_entry, :date_receipt, :palletized, :quantity_pallets, 
        :observation, :charge_discharge,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy]
        )
    end

    def render_input_control(task)
        report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'ocorrencia.tlf')
        
        report.start_new_page
        data_input_control(report)
        task.nfe_xmls.nfe.order("nfe_xmls.numero").each do |nfe|
          report.page.item(:nfe_numero).value(nfe.numero)
          report.page.item(:nfe_peso).value("#{number_to_currency(nfe.peso, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          report.page.item(:nfe_volume).value("#{number_to_currency(nfe.volume, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          report.page.item(:client_name).value(nfe.target_client.nome)
          report.page.item(:client_cnpj).value(nfe.target_client.cpf_cnpj)
          report.page.item(:client_cidade).value(nfe.target_client.cidade)
          nfe.item_input_controls.joins(:product).order("products.cod_prod").each do |item|
            report.list.add_row do |row|
              row.values prod_id: item.product.cod_prod, 
                     prod_name: item.product.descricao,
                     prod_total: item.qtde,
                     prod_und: item.unid_medida
              end
          end
          report.start_new_page
          data_input_control(report)
        end
        
        send_data report.generate, filename: "ocorrencia_#{task.id}_.pdf", 
                                   type: 'application/pdf', 
                                   disposition: 'attachment'
    end    

    def data_input_control(report)
      report.page.item(:input_control_id).value(@input_control.id)
      report.page.item(:driver_name).value(@input_control.driver.nome)
      report.page.item(:driver_cpf).value(@input_control.driver.cpf)
      report.page.item(:placa_cavalo).value(@input_control.place)
      report.page.item(:placa_reboque).value(@input_control.place_cart)
      #report.page.item(:placa_reboque_2).value(@input_control.place_cart_2)
      report.page.item(:carrier_name).value(@input_control.carrier.nome)
      report.page.item(:carrier_cnpj).value(@input_control.carrier.cnpj)
    end

end
