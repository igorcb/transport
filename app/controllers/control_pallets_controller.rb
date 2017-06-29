class ControlPalletsController < ApplicationController
  before_action :set_control_pallet, only: [:show, :edit, :update, :destroy, :print]

  respond_to :html

  def selection_pallet
    @control_pallets = ControlPallet.open_entry
  end

  def generate_ordem_service
    ControlPallet.create_ordem_service(params[:controle_pallete])
    redirect_to control_pallets_path, flash: { success: "Ordem Service create was successful" }
  end

  def estoque
    @control_pallets = ControlPallet.select(:client_id).uniq(:client_id)
  end

  def index
    @control_pallets = ControlPallet.order_desc
    respond_with(@control_pallets)
  end

  def show
    respond_with(@control_pallet)
  end

  def new
    @control_pallet = ControlPallet.new
    respond_with(@control_pallet)
  end

  def edit
  end

  def create
    @control_pallet = ControlPallet.new(control_pallet_params)
    source_client  = Client.find_by_cpf_cnpj(params[:source_client_cpf_cpnj])
    @control_pallet.client_id = source_client.id if source_client.present?
    respond_to do |format|
      if @control_pallet.save
        format.html { redirect_to @control_pallet, flash: { success: "Pallet was successfully created." } }
        format.json { render action: 'show', status: :created, location: @control_pallet }
      else
        format.html { render action: 'new' }
        format.json { render json: @control_pallet.errors, status: :unprocessable_entity }
      end
    end

  end

  def update
    @control_pallet.update(control_pallet_params)
    respond_with(@control_pallet)
  end

  def destroy
    @control_pallet.destroy
    respond_with(@control_pallet)
  end

  def print
    respond_to do |format|
      format.html
      format.pdf { render_print_pallet(@control_pallet) }
    end
  end

  private
    def set_control_pallet
      @control_pallet = ControlPallet.find(params[:id])
    end

    def control_pallet_params
      params.require(:control_pallet).permit(:data, :qte, :tipo, :historico, :nfe, :nfd, :nfe_original, :nfd_original, :client_id, :carrier_id, :ids)
    end

    def render_print_pallet(control_pallet)

      def barcode(type, data, png_opts = {})
        code = case type
        when :ean_13
          Barby::EAN13.new(data)
        when :ean_8
          Barby::EAN8.new(data)
        when :ean_128
          Barby::Code128C.new(data)
        when :qr_code
          Barby::QrCode.new(data)
        end
        StringIO.new(code.to_png(png_opts))
      end

      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'pallets.tlf')
      report.start_new_page

      emitido = "EMITIDO EM: #{date_br(Date.current)} as #{time_br(Time.current)} por #{current_user.email} - IP. #{current_user.current_sign_in_ip}"
      nfe_xml = NfeXml.where(numero: control_pallet.nfe).first

      ### cabecalho esquerdo
      report.page.item(:vale_no).value("VALE Nº #{control_pallet.id}")
      report.page.item(:motorista_nome).value(nfe_xml.input_control.driver.nome)
      report.page.item(:motorista_cpf).value(nfe_xml.input_control.driver.cpf)
      report.page.item(:veiculo).value(nfe_xml.input_control.place)
      report.page.item(:data).value(date_br(control_pallet.data))
      report.page.item(:transportadora).value("#{control_pallet.carrier.nome} CNPJ: #{control_pallet.carrier.cnpj}, Cidade: #{control_pallet.carrier.cidade}/#{control_pallet.carrier.estado}")
      report.page.item(:nf_original).value(control_pallet.nfe)
      report.page.item(:nf_devolucao).value(control_pallet.nfd)
      report.page.item(:qtde_original).value(control_pallet.qte)
      report.page.item(:qtde_devolucao).value(control_pallet.qte) if control_pallet.nfd_original.present?
      report.page.item(:chave_nfe_original).value(control_pallet.nfe_original)
      report.page.item(:chave_nfe_devolucao).value(control_pallet.nfd_original)
      report.page.item(:cod_bar_nfe_original).src(barcode(:ean_128, control_pallet.nfe_original))
      report.page.item(:cod_bar_nfe_devolucao).src(barcode(:ean_128, control_pallet.nfd_original)) if control_pallet.nfd_original.present? 
      send_data report.generate, filename: "pallet_#{control_pallet.id}_.pdf", 
                                   type: 'application/pdf', 
                                   disposition: 'inline'


    end
end
