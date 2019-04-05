class DirectChargesController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  before_action :authenticate_user!
  before_action :set_direct_charge, only: [:show, :edit, :update, :destroy, :select_nfe, :finish_typing]
  #load_and_authorize_resource

  respond_to :html

  def create_ordem_service
    @direct_charge = DirectCharge.find(params[:id])

    #puts ">>>>>>>>>>>>>>>>>>>>> DirectCharge: #{@direct_charge.id}"

    if params[:nfe].blank?
      flash[:danger] = "Select at least one nfe to generate the ordem service."
      respond_with(@direct_charge)
      return
    end
    if !@direct_charge.status_finish_typing?
      flash[:danger] = "First declare that you finish_typing"
      respond_with(@direct_charge)
      return
    elsif @direct_charge.date_charge.blank?
      flash[:danger] = "Date Charge can not be blank."
      respond_with(@direct_charge)
      return
    end
    # criar um modulo para get_hash_ids e check_client_billing
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    #puts ">>>>>>>>>>>>>>>>>>>>>>> check_client_billing: #{InputControl.check_client_billing?(ids)} <<<<<<<<<<<<<<<<<<<<<<<<"
    if !InputControl.check_client_billing?(ids)
      flash[:danger] = "Customer invoices are not the same."
      respond_with(@direct_charge)
      return
    end
    DirectCharge.create_ordem_service_input_controls({id: params[:id], nfe: ids})
    #puts ">>>>>>>>>>>>>ID Direct Charge: #{@direct_charge.id} "
    respond_with(@direct_charge)
  end

  def finish_typing
    result = @direct_charge.finish_typing
    if result[:success]
      flash[:success] = result[:message]
    else
      flash[:danger] = "Error finish typing Direct Charge. #{result[:message]}"
    end
    redirect_to direct_charge_path(@direct_charge)
  end


  def index
    @direct_charges = DirectCharge.all
    respond_with(@direct_charges)
  end

  def show
    #respond_with(@direct_charge)
    # se a capacidade do veículo for menor que o peso da nota mostra alert
    @warnings = []
    if @direct_charge.vehicle_horse.present?
      @warnings.push("Capacity of the traction vehicle does not support the weight of the load.") if @direct_charge.vehicle_horse.capacity.to_f < @direct_charge.weight
    end
    if @direct_charge.vehicle_cart_first.present?
      @warnings.push("Capacity of the first cart does not support the weight of the load.") if @direct_charge.vehicle_cart_first.capacity.to_f < @direct_charge.weight
    end
    if @direct_charge.vehicle_cart_second.present?
      warning << "Capacity of the first cart does not support the weight of the load" if @direct_charge.vehicle_cart_second.capacity.to_f < @direct_charge.weight
    end
    respond_with(@direct_charge)
  end

  def new
    @direct_charge = DirectCharge.new
    respond_with(@direct_charge)
  end

  def edit
  end

  def create
    driver  = Driver.find_by_cpf(params[:driver_cpf])
    carrier = Carrier.find_by_cnpj(params[:carrier_cnpj])
    billing_client  = Client.find_by_cpf_cnpj(params[:billing_client_cpf_cpnj])
    @direct_charge = DirectCharge.new(direct_charge_params)

    @direct_charge.driver_id = driver.id
    @direct_charge.carrier_id = carrier.id
    @direct_charge.billing_client_id = billing_client.id

    # client_table_price = get_client_table_price(billing_client.id)
    # @direct_charge.client_table_price_id = client_table_price.id

    if params[:direct_charge][:stretch_route_id].present? && params[:direct_charge][:type_service_id].present?
      client_table_price = get_client_table_price
      @input_control.client_table_price_id = client_table_price.id
    end


    @direct_charge.user_id = current_user.id

    @direct_charge.save
    respond_with(@direct_charge)
  end

  def update
    @direct_charge.update(direct_charge_params)
    respond_with(@direct_charge)
  end

  def destroy
    @direct_charge.destroy
    respond_with(@direct_charge)
  end

  def add_nfe_xml
    @direct_charge = DirectCharge.find(params[:id])
  end

  def attach_xml
    @direct_charge = DirectCharge.find(params[:id])
    nfe_not_exist = check_nfe_xmls(params[:nfe_xmls])
    if nfe_not_exist.present?
      flash[:danger] = "XML #{nfe_not_exist}, não existe."
      redirect_to add_nfe_xml_input_control_path(@direct_charge)
      return
    end
    has_present_and_not_process = has_present_and_not_process_nfe_xmls(params[:nfe_xmls])
    if has_present_and_not_process.present?
      flash[:danger] = "XML #{has_present_and_not_process}, não processado."
      redirect_to add_nfe_xml_input_control_path(@direct_charge)
      return
    end
    has_present = has_present_nfe_xmls(params[:nfe_xmls])
    if has_present.present?
      flash[:danger] = "XML #{has_present}, já cadastrado nesta remessa de entrada."
      redirect_to add_nfe_xml_input_control_path(@direct_charge)
      return
    end

    #NfeXml.processado.where(chave: params[:nfe_xmls]).update_all(nfe_type: "InputControl", nfe_id: @input_control.id)
    result = DirectCharge.add_nfe_xml_direct_charge(@direct_charge, params[:nfe_xmls])
    if result[:success] == true
      flash[:success] = "Attach NF-e to input control was successfully"
    else
      flash[:danger] = "NF-e is not Attach."
    end
    redirect_to (@direct_charge)
  end

  private
    def set_direct_charge
      @direct_charge = DirectCharge.find(params[:id])
    end

    def get_client_table_price
      client_table_price = ClientTablePrice.where(client_id: @direct_charge.billing_client_id,
                                           stretch_route_id: params[:input_control][:stretch_route_id],
                                            type_service_id: params[:input_control][:type_service_id]).first
      client_table_price
    end

    def direct_charge_params
      params.require(:direct_charge).permit(:carrier_id, :driver_id, :place, :place_cart, :place_cart_2, :date_charge, :palletized,
        :quantity_pallets, :weight, :volume, :source_state, :source_city, :target_state, :target_city,
        :observation, :user_id, :shipment, :stretch_route_id, :type_service_id,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy],
        assets_attributes: [:asset, :user_id, :id, :_destroy]

        )
    end

    def check_nfe_xmls(array_nfe_xml)
      nfe_not_exist = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |arq|
        nfe_not_exist.push(arq) if !NfeXml.where(asset_file_name: "#{arq}.xml").or(NfeXml.where(asset_file_name: "#{arq}-procNFe.xml")).first.present?
      end
      nfe_not_exist
    end

    def has_present_and_not_process_nfe_xmls(array_nfe_xml)
      has_present = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |arq|
        has_present.push(arq) if NfeXml.nao_processado.where(asset_file_name: "#{arq}.xml").or(NfeXml.nao_processado.where(asset_file_name: "#{arq}-procNFe.xml")).first.present?
      end
      has_present
    end

    def has_present_nfe_xmls(array_nfe_xml)
      has_present = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |xml|
        has_present.push(xml) if NfeXml.where(nfe_type: "DirectCharge", nfe_id: @direct_charge.id, chave: xml).first.present?
      end
      has_present
    end

    def has_present_nfe_xmls_other_input_control(array_nfe_xml)
      has_present = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |xml|
        has_present.push(xml) if NfeXml.where(nfe_type: "DirectCharge", chave: xml).first.present?
      end
      has_present
    end
end
