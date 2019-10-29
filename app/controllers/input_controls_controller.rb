class InputControlsController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

  before_action :authenticate_user!
  before_action :set_input_control, only: [:show, :edit, :update, :destroy, :select_nfe, :question]
  load_and_authorize_resource

  respond_to :html, :js

  def index
    #@input_controls = InputControl.order(date_entry: :desc, time_entry: :desc)
    #@q = Boarding.where(status: -1).search(params[:q])
    @q = InputControl.where(status: -1).search(params[:q])
    @input_controls = InputControl.includes(:carrier, :driver).the_day_scheduled.order(date_scheduled: :desc, time_scheduled: :desc)
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
    @input_control.action_inspectors.build
    respond_with(@input_control)
  end

  def edit
    # if @input_control.status != InputControl::TypeStatus::OPEN
    #   flash[:danger] = "You can not edit an input control that has already been fed into the CD."
    #   redirect_to @input_control
    #   return
    # end
    @input_control.action_inspectors.build if !@input_control.action_inspectors.present?
  end

  def create
    driver  = Driver.find_by_cpf(params[:driver_cpf])
    carrier = Carrier.find_by_cnpj(params[:carrier_cnpj])
    billing_client  = Client.find_by_cpf_cnpj(params[:billing_client_cpf_cpnj])

    @input_control.driver_id = driver.id
    @input_control.carrier_id = carrier.id
    @input_control.user_id = current_user.id
    @input_control.billing_client_id = billing_client.id #if billing_client.present?
    if params[:input_control][:stretch_route_id].present? && params[:input_control][:type_service_id].present?
      client_table_price = get_client_table_price
      @input_control.client_table_price_id = client_table_price.id
    end

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
    respond_to do |format|
      if params[:input_control][:stretch_route_id].present? && params[:input_control][:type_service_id].present?
        client_table_price = get_client_table_price
        @input_control.client_table_price_id = client_table_price.id
      end
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

  def report_team
    if !@input_control.driver_checkin?
      flash[:danger] = "The driver did not checkin"
      redirect_to (sup_input_controls_path)
      return
    end
    render layout: false if params[:ajax] == "true";
  end

  def update_report_team
    respond_to do |format|
      if @input_control.update(input_control_params)
        format.html { redirect_to sup_input_controls_path, flash: { success: "InputControl report team was successfully updated." } }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @input_control.errors, status: :unprocessable_entity }
      end
    end
  end

  def items
    @request_items = request.base_url + "/input_controls/#{params[:id]}/items/"
    @ean = params["ean"] == """" ? nil : params["ean"]

    # if @ean
    #   redirect_to @request_items
    # end

    @input_control = InputControl.where(id: params["id"]).first
    @conference = @input_control.conferences.last
    @conference_items = @conference.conference_items.order(id: :desc) if  @conference.present?

    if @ean.present?
      @product = Product.where("cod_prod = ? or ean_box = ?", params["ean"], params["ean"]).first
    end
  end

  def has_avaria
  end

  def update_has_avaria
    if params["has_avaria"] == "false"
      @input_control.date_finish_avaria = Date.today
      @input_control.time_finish_avaria = Time.now
    end
    @input_control.date_start_avaria = Date.today
    @input_control.time_start_avaria = Time.now
    @input_control.avaria = params["has_avaria"]
    @input_control.breakdown_user_id = current_user.id
    @input_control.save!

    # redirect_to oper_input_controls_path
    if params["has_avaria"] == "false"
      redirect_to oper_input_controls_path
    else
      redirect_to input_control_conference_conference_breakdowns_path(@input_control, @input_control.conferences.last)
    end
  end


  def analize
    result = InputControls::CheckConferenceService.new(@input_control).call
    if result[:success]
      flash[:success] = result[:message]
    else
      flash[:danger] = result[:message]
    end
    redirect_to sup_input_controls_path
  end

  def review_conference
    @input_control = InputControl.where(id: params["id"]).first

    @item_input_controls = @input_control.item_input_controls.select(:product_id).group(:product_id).sum(:qtde)
    @conference_1 = @input_control.conferences.first
    @conference_2 = @input_control.conferences.second
    @conference_3 = @input_control.conferences.third
    @conference_item_1 = @conference_1.conference_items.select(:product_id).group(:product_id).sum(:qtde_oper) if @conference_1.present?
    @conference_item_2 = @conference_2.conference_items.select(:product_id).group(:product_id).sum(:qtde_oper) if @conference_2.present?
    @conference_item_3 = @conference_3.conference_items.select(:product_id).group(:product_id).sum(:qtde_oper) if @conference_3.present?
    @total_qtde = @input_control.item_input_controls.sum(:qtde)
    @total_qtde_1 = @input_control.conferences.first.conference_items.sum(:qtde_oper) if @conference_1.present?
    @total_qtde_2 = @input_control.conferences.second.conference_items.sum(:qtde_oper) if @conference_2.present?
    @total_qtde_3 = @input_control.conferences.third.conference_items.sum(:qtde_oper) if @conference_3.present?
    @count_items = @item_input_controls.count

    @count_items_1 =  @conference_item_1.count if @conference_1.present?
    @count_items_2 =  @conference_item_2.count if @conference_2.present?
    @count_items_3 =  @conference_item_3.count if @conference_3.present?

    @count_items_1 = @count_items_1.present? ? @count_items_1 : 0
    @count_items_2 = @count_items_2.present? ? @count_items_2 : 0
    @count_items_3 = @count_items_3.present? ? @count_items_3 : 0

    @avaria = @input_control.conferences.last.conference_breakdowns.select(:product_id).group(:product_id).sum(:qtde)

    @sobras = InputControls::DiferenceArrayService.new(@input_control).call
    #if @count_items_1 > @count_items

  end

  def duplicate_conference
    input_control = InputControl.where(id: params["id"]).first
    conference = Conferences::DuplicateConferenceService.new(input_control).call
    redirect_to review_conference_input_control_path
  end

  def documents
  end

  def documents_upload

    # render inline: input_control_params.inspect
    # return
    @input_control.update(input_control_params)
    @input_control.save
    # respond_with(@input_control)
    redirect_to documents_input_control_path(@input_control), flash: { success: "Input Control was successfully created." }


  end

  def documents_destroy
    Asset.find(params[:asset_id]).destroy
    redirect_to documents_input_control_path(@input_control), flash: { success: "Input Control was successfully created." }

  end

  def list_input_scheduling
    @input_controls = InputControl.where.not(container: nil)
  end

  def printing; end

  def question;
    if @input_control.status != InputControl::TypeStatus::RECEIVED
      flash[:danger] = "To send a comment or report breakdown the InputControl must be as RECEIVED"
      redirect_to (@input_control)
      return
    elsif @input_control.date_receipt.blank?
      flash[:danger] = "Receipt date can not be blank."
      redirect_to (@input_control)
      return
    end
  end

  def quitter
    respond_to do |format|
      format.html
      # Example: Basic Usage
      format.pdf { render_quitter_input_control(@input_control) }
    end
  end

  def print_products
    @company = Company.first
    #byebug
    #puts ">>>>>>>>>>>>>>>> CalculateLiquidity: #{params[:value]}"
    file_name = "InputControl_#{@input_control.id}_product.pdf"
    respond_to do |format|
      #format.html
      format.pdf do
        pdf = InputControls::PrintProductPdf.new(@input_control, current_user)
        send_data pdf.render, filename: file_name, type: 'application/pdf'
      end
    end
  end

  def print_products_conference
    @company = Company.first
    #byebug
    #puts ">>>>>>>>>>>>>>>> CalculateLiquidity: #{params[:value]}"
    file_name = "InputControl_#{@input_control.id}_product.pdf"
    respond_to do |format|
      #format.html
      format.pdf do
        pdf = InputControls::PrintProductConferencePdf.new(@input_control, current_user)
        send_data pdf.render, filename: file_name, type: 'application/pdf'
      end
    end
  end

  def print_blind
    respond_to do |format|
      format.html
      format.pdf { render_blind_input_control(@input_control) }
    end
  end

  def tag
    respond_to do |format|
      format.html
      format.pdf { render_tag_input_control(@input_control) }
    end
  end

  def finish_typing
    if @input_control.place_horse.blank?
      flash[:danger] = "Place Horse is not present."
      redirect_to input_control_path(@input_control)
      return
    elsif @input_control.place_cart.blank?
      flash[:danger] = "Place Cart is not present."
      redirect_to input_control_path(@input_control)
      return
    end
    if @input_control.finish_typing
      #@input_control.update_attributes(received_user_id: current_user.id)
      flash[:success] = "Input Control was successfully finish typing"
    else
      @input_control.errors.full_messages.each { |msg| flash[:danger] = msg }
    end
    redirect_to input_control_path(@input_control)
  end

  def admin
    @input_controls = InputControl.available_admin
  end

  def admin_show
    @input_controls = InputControl.find params[:id]
  end

  def oper
    #@input_controls = InputControl.the_day_scheduled
    @input_controls = InputControl.available_operator
  end

  def sup_search
    @q = InputControl.includes(:carrier, :driver).order(date_entry: :desc, time_entry: :desc).search(params[:query])
    @input_controls = @q.result
    respond_with(@input_controls) do |format|
      format.js
    end
  end

  def sup
    @q = InputControl.where(status: -1).search(params[:q])
    @input_controls = InputControl.the_day_scheduled

  end

  def sup_qtde_pallets
    #code
  end

  def received
  end

  def start_conference
    input_control = InputControl.where(id: params[:id]).first
    @result = InputControls::ConferenceService.new(input_control, current_user).call
    if @result[:success] == true
      flash[:success] = @result[:message]
      redirect_to items_input_control_path(input_control)
    else
      flash[:error] = @result[:message]
      redirect_to oper_input_controls_path
    end
  end

  def update_start
    if params[:input_control][:place_confirmed].blank?
      flash[:danger] = "Place is not present."
      redirect_to oper_input_controls_path
      return
    elsif params[:input_control][:place_confirmed].upcase != @input_control.place_cart.upcase
      flash[:danger] = "Place is not present in Input Control."
      redirect_to oper_input_controls_path
      return
    end

    @input_control.started_user_id = current_user.id
    @input_control.update(input_control_params)
    InputControl.start(params[:id])

    redirect_to oper_input_controls_path, flash: { success: "Input Control was successfully started" }
  end

  def confirm_received
    input_control = InputControl.where(id: params["id"]).first;
    if params[:input_control][:quantity_pallets].blank?
      flash[:danger] = "Qtde Pallets is not present."
      redirect_to oper_input_controls_path
      return
    end
    if @input_control.received
      @input_control.update_attributes(quantity_pallets: params[:input_control][:quantity_pallets])
      flash[:success] = "Input Control was successfully received"
    else
      flash[:danger] = "Error receiving input control."
    end
    redirect_to oper_input_controls_path
  end

  def reschedule

  end

  def update_reschedule
    if params[:input_control][:date_scheduled].blank?
      flash[:danger] = "Date Scheduled is not present."
      redirect_to reschedule_input_control_path(@input_control)
      return
    elsif params[:input_control][:time_scheduled].blank?
      flash[:danger] = "Time Scheduled is not present."
      redirect_to reschedule_input_control_path(@input_control)
      return
    elsif params[:input_control][:motive_scheduled].blank?
      flash[:danger] = "Motive Scheduled is not present."
      redirect_to reschedule_input_control_path(@input_control)
      return
    elsif params[:input_control][:motive_scheduled].length < 15
      flash[:danger] = "Reschedule motive is less than 15 characters"
      redirect_to reschedule_input_control_path(@input_control)
      return
    end
    if @input_control.update(input_control_params)
      flash[:success] = "Input Control was successfully reschedule"
    else
      flash[:danger] = "Error reschedule input control."
    end
    redirect_to(@input_control)
  end

  def create_ordem_service
    if params[:nfe].blank?
      flash[:danger] = "Select at least one nfe to generate the ordem service."
      respond_with(@input_control)
      return
    end
    # if !@input_control.status_received?
    #   flash[:danger] = "First declare that you received the products"
    #   respond_with(@input_control)
    #   return
    # end
    # criar um modulo para get_hash_ids e check_client_billing
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    #puts ">>>>>>>>>>>>>>>>>>>>>>> check_client_billing: #{InputControl.check_client_billing?(ids)} <<<<<<<<<<<<<<<<<<<<<<<<"
    if !InputControl.check_client_billing?(ids)
      flash[:danger] = "Customer invoices are not the same."
      respond_with(@input_control)
      return
    end
    ids = OrdemService.get_hash_ids(params[:nfe][:ids])
    if !InputControl.check_client?(ids)
      flash[:danger] = "Client target are not the same."
      respond_with(@input_control)
      return
    end

    if @input_control.carrier_credentials?
      if InputControl.client_not_credentials_sefaz?(@input_control.nfe_xmls.client_ids) &&
        @input_control.action_inspector.blank? &&

        flash[:danger] = "Existe cliente que não são credenciados a sefaz. Por favor inserir o No da Ação Fiscal"
        respond_with(@input_control)
        return
      end
    end
    InputControl.create_ordem_service_input_controls({id: params[:id], nfe: ids})
    puts ">>>>>>>>>>>>>ID Input Control: #{@input_control.id} "
    respond_with(@input_control)
  end

  def select_nfe
    if @input_control.status == InputControl::TypeStatus::OPEN
      flash[:danger] = "Can not generate Ordem Service while the Input Control is in Typing Digital."
      redirect_to (@input_control)
      return
    end
    # if !@input_control.status_received?
    #   flash[:danger] = "First declare that you received the products"
    #   redirect_to (@input_control)
    #   return
    # end
    # if @input_control.date_receipt.blank?
    #   flash[:danger] = "Receipt date can not be blank."
    #   redirect_to (@input_control)
    #   return
    # end
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
    elsif @input_control.status != InputControl::TypeStatus::RECEIVED
      flash[:danger] = "For pallet storage the InputControl must be in receipt status."
      redirect_to (@input_control)
      return
    end
  end

  def comments
    if @input_control.status != InputControl::TypeStatus::RECEIVED
      flash[:danger] = "To send a comment or report breakdown the InputControl must be as RECEIVED"
      redirect_to (@input_control)
      return
    elsif @input_control.date_receipt.blank?
      flash[:danger] = "Receipt date can not be blank."
      redirect_to (@input_control)
      return
    end
    @comment = Comment.new
  end

  def received_weight_search
    start_date = params[:start_date].blank? ? Date.current.beginning_of_month - 1.month : params[:start_date].to_date
    end_date = params[:end_date].blank? ? Date.current : params[:end_date].to_date
    @input_controls = InputControl.joins(nfe_xmls: [source_client: [:group_client]])
                                  .where("group_clients.id = ? and date_receipt >= ? and date_receipt <= ?", params[:group_client_id], start_date.to_date, end_date.to_date)
                                  .select_date_receipt
    @input_control_total = InputControl.joins(nfe_xmls: [source_client: [:group_client]])
                                  .where("group_clients.id = ? and date_receipt >= ? and date_receipt <= ?", params[:group_client_id], start_date.to_date, end_date.to_date)
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

  def billing
    #@q = InputControl.where(status: -1).search(params[:q])
    @input_controls = InputControl.includes(:carrier, :driver).where(status: InputControl::TypeStatus::CLOSED).order(id: :desc)
    respond_with(@input_controls)
  end

  def attach_xml
    nfe_not_exist = check_nfe_xmls(params[:nfe_xmls])
    if nfe_not_exist.present?
      flash[:danger] = "XML #{nfe_not_exist}, não existe."
      redirect_to add_nfe_xml_input_control_path(@input_control)
      return
    end
    has_present_and_not_process = has_present_and_not_process_nfe_xmls(params[:nfe_xmls])
    if has_present_and_not_process.present?
      flash[:danger] = "XML #{has_present_and_not_process}, não processado."
      redirect_to add_nfe_xml_input_control_path(@input_control)
      return
    end
    has_present = has_present_nfe_xmls(params[:nfe_xmls])
    if has_present.present?
      flash[:danger] = "XML #{has_present}, já cadastrado nesta remessa de entrada."
      redirect_to add_nfe_xml_input_control_path(@input_control)
      return
    end

    #NfeXml.processado.where(chave: params[:nfe_xmls]).update_all(nfe_type: "InputControl", nfe_id: @input_control.id)
    result = InputControl.add_nfe_xml_input_control(@input_control, params[:nfe_xmls])
    if result[:success] == true
      flash[:success] = "Attach NF-e to input control was successfully"
    else
      flash[:danger] = result[:message]
    end
    redirect_to (@input_control)
  end

  private
    def set_input_control
      @input_control = InputControl.find(params[:id])
    end

    def input_control_params
      params.require(:input_control).permit(:carrier_id, :driver_id, :billing_client_id, :place, :place_cart,
        :place_cart_2, :date_entry, :time_entry, :date_receipt, :palletized, :quantity_pallets,
        :observation, :charge_discharge, :shipment, :team, :dock, :hangar, :container,
        :stretch_route_id, :type_service_id, :place_confirmed, :place_horse, :charge_type_delivery,
        :date_scheduled, :time_scheduled, :motive_scheduled,
        nfe_xmls_attributes: [:asset, :equipamento, :id, :_destroy],
        action_inspectors_attributes: [:number, :id, :_destroy],
        assets_attributes: [:asset, :id, :_destroy]
        )
    end

    def check_nfe_xmls(array_nfe_xml)
      nfe_not_exist = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |arq|
        #nfe_not_exist.push(arq) if !NfeXml.where(asset_file_name: "#{arq}.xml").or(NfeXml.where(asset_file_name: "#{arq}-procNFe.xml")).first.present?
        nfe_not_exist.push(arq) if !NfeXml.where("asset_file_name LIKE ?", "%#{arq}%").first.present?
      end
      nfe_not_exist
    end

    def has_present_and_not_process_nfe_xmls(array_nfe_xml)
      has_present = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |arq|
        # has_present.push(arq) if NfeXml.nao_processado.where(asset_file_name: "#{arq}.xml").
        #                       or(NfeXml.nao_processado.where(asset_file_name: "#{arq}-nfe.xml").
        #                       or(NfeXml.nao_processado.where(asset_file_name: "#{arq}-procNFe.xml")).first.present?
        has_present.push(arq) if NfeXml.nao_processado.where(nfe_type: nil).where("asset_file_name LIKE ?", "%#{arq}%").first.present?
      end
      has_present
    end

    def has_present_nfe_xmls(array_nfe_xml)
      has_present = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |xml|
        has_present.push(xml) if NfeXml.where(nfe_type: "InputControl", nfe_id: @input_control.id, chave: xml).first.present?
      end
      has_present
    end

    def has_present_nfe_xmls_other_input_control(array_nfe_xml)
      has_present = []
      nfe_xmls = array_nfe_xml
      nfe_xmls.each do |xml|
        has_present.push(xml) if NfeXml.where(nfe_type: "InputControl", chave: xml).first.present?
      end
      has_present
    end

    def get_client_table_price
      client_table_price = ClientTablePrice.where(client_id: @input_control.billing_client_id,
                                           stretch_route_id: params[:input_control][:stretch_route_id],
                                            type_service_id: params[:input_control][:type_service_id]).first
      client_table_price
    end

    def render_tag_input_control(input_control)
      report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'tag.tlf')
      report.start_new_page

      @company = Company.first
      report.page.item(:image_logo).src(@company.image.path) #@company.image.url

      tag_header(report, input_control)

      input_control.nfe_xmls.nfe.order("nfe_xmls.numero").each do |nfe|
        report.page.item(:peso).value(nfe.peso)
        report.page.item(:cidade).value("#{nfe.target_client.cidade}/#{nfe.target_client.estado}")
        report.page.item(:nota_fiscal).value(nfe.numero)
        report.page.item(:qtde_pallets).value(nfe.qtde_pallet)
        report.page.item(:client).value(nfe.target_client.nome)
        report.start_new_page
        tag_header(report, input_control)
      end
      send_data report.generate, filename: "tag#{input_control.id}_.pdf",
                                 type: 'application/pdf',
                                 disposition: 'inline'

    end

    def tag_header(report, input_control)
      report.page.item(:no_remessa).value(input_control.id)
      report.page.item(:data_entrada).value(input_control.date_entry)
      report.page.item(:equipe).value(input_control.team_name)
    end

    def render_blind_input_control(task)
        if task.hangar.blank?
          flash[:danger] = "Select hangar on input_controls"
          redirect_to input_control_path(task)
          return
        end
        if task.dock.blank?
          flash[:danger] = "Select dock on input_controls"
          redirect_to input_control_path(task)
          return
        end
        if task.team.blank?
          flash[:danger] = "Select team on input_controls"
          redirect_to input_control_path(task)
          return
        end

        report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'ocorrencia.tlf')

        report.start_new_page

        print_header_pdf(report)

        data_input_control(report)
        task.nfe_xmls.nfe.order("nfe_xmls.numero").each do |nfe|
          report.page.item(:nfe_numero).value(nfe.numero)
          # report.page.item(:nfe_peso).value("#{number_to_currency(nfe.peso, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          # report.page.item(:nfe_volume).value("#{number_to_currency(nfe.volume, precision: 3, unit: "", separator: ",", delimiter: ".")}")
          report.page.item(:client_name).value(nfe.target_client.nome)
          report.page.item(:client_cnpj).value(nfe.target_client.cpf_cnpj)
          report.page.item(:client_cidade).value(nfe.target_client.cidade)
          nfe.item_input_controls.joins(:product).order("products.cod_prod").each do |item|
            report.list.add_row do |row|
              breakdown = Breakdown.where(breakdown_type: 'InputControl', breakdown_id: item.input_control_id, product_id: item.product_id).first
              row.values prod_id: item.product.cod_prod,
                     prod_name: item.product.descricao
              end
          end
          report.start_new_page
          data_input_control(report)
        end

        send_data report.generate, filename: "blind#{task.id}_.pdf",
                                   type: 'application/pdf',
                                   disposition: 'attachment'
    end

    def render_input_control(task)
        if task.hangar.blank?
          flash[:danger] = "Select hangar on input_controls"
          redirect_to input_control_path(task)
          return
        end
        if task.dock.blank?
          flash[:danger] = "Select dock on input_controls"
          redirect_to input_control_path(task)
          return
        end
        if task.team.blank?
          flash[:danger] = "Select team on input_controls"
          redirect_to input_control_path(task)
          return
        end

        report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'ocorrencia.tlf')

        # Thinreports::Report.generate filename: t.output_filename do |report|
        #   report.use_layout t.layout_filename
        #   report.list.header title: 'Prices'
        # end
        report.start_new_page

        print_header_pdf(report)

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
              breakdown = Breakdown.where(breakdown_type: 'InputControl', breakdown_id: item.input_control_id, product_id: item.product_id).first
              sobras = breakdown.nil? ? nil : breakdown.sobras
              faltas = breakdown.nil? ? nil : breakdown.faltas
              avarias = breakdown.nil? ? nil : breakdown.avarias
              und_med = breakdown.nil? ? item.unid_medida : breakdown.unid_medida
              row.values prod_id: item.product.cod_prod,
                     prod_name: item.product.descricao,
                     prod_total: item.qtde_pallet,
                     qtde: item.qtde,
                     sobras: sobras,
                     faltas: faltas,
                     avarias: avarias,
                     und_med: item.unid_medida
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
      report.page.item(:galpao).value(@input_control.hangar)
      report.page.item(:doca).value(@input_control.dock)
      report.page.item(:equipe).value(@input_control.team_name)
    end

end
