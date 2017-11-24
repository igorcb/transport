class ControlPalletInternalsController < ApplicationController
  before_action :set_control_pallet_internal, only: [:show, :edit, :update, :destroy, :term_pallet]

  respond_to :html

  def index
    @control_pallet_internals = ControlPalletInternal.all
    respond_with(@control_pallet_internals)
  end

  def show
    respond_with(@control_pallet_internal)
  end

  def new
    @control_pallet_internal = ControlPalletInternal.new
    respond_with(@control_pallet_internal)
  end

  def edit
  end

  def create
    @control_pallet_internal = ControlPalletInternal.new(control_pallet_internal_params)
    @control_pallet_internal.save
    respond_with(@control_pallet_internal)
  end

  def update
    @control_pallet_internal.update(control_pallet_internal_params)
    respond_with(@control_pallet_internal)
  end

  def destroy
    @control_pallet_internal.destroy
    respond_with(@control_pallet_internal)
  end

  def term_pallet
    respond_to do |format|
      format.html
      format.pdf { render_term_pallet(@control_pallet_internal) }
    end
  end

  private
    def set_control_pallet_internal
      @control_pallet_internal = ControlPalletInternal.find(params[:id])
    end

    def control_pallet_internal_params
      params.require(:control_pallet_internal).permit(:responsable_type, :responsable_id, :type_account, :type_launche, :equipament, :date_launche, :qtde, :historic, :observation)
    end

    def render_term_pallet(control)
      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'term_pallet.tlf')
      # valor = (quitter.total_pago.to_f * 100).to_i
      # local_data = "FORTALEZA, #{l Date.today , format: :long }"
      report.start_new_page
      # cabecalho empresa

      @company = Company.first
      report.page.item(:image_logo).src(@company.image.path) #@company.image.url
      report.page.item(:emp_fantasia).value(@company.fantasia)
      report.page.item(:emp_razao_social).value(@company.razao_social)
      report.page.item(:emp_cnpj).value("CNPJ: " + @company.cnpj)
      report.page.item(:emp_fone).value("CONTATO: " + @company.phone_first)
      report.page.item(:emp_cidade).value(@company.cidade_estado)

      item = control.boarding.boarding_vehicles.first

      emitido = "EMITIDO EM: #{date_br(Date.current)} as #{time_br(Time.current)} por #{current_user.email} - IP. #{current_user.current_sign_in_ip}"
      
      texto = "Eu, #{control.responsable.nome}, motorista, \n" \
              "portador da CNH #{control.responsable.cnh} e do CPF nº #{control.responsable.cpf},\n" \
              "venho por meio deste declarar que sou responsável pelos #{control.qtde} pallets BPR do\n" \
              "embarque de Nº #{control.boarding_id}, realizado na empresa #{@company.razao_social}\n" \
              "pessoa jurídica de direito privado, CNPJ #{@company.cnpj}, estando ciente\n" \
              "de que os pallets supracitados foram carregados em perfeito estado de \n" \
              "conservação no meu veículo de PLACA #{item.vehicle.placa}, RENAVAN #{item.vehicle.renavan}, \n" \
              "CHASSI #{item.vehicle.chassi}." \
              "\n \n" \
              "Dessa forma, caso ocorra a retenção dos pallets pelo cliente, irei solicitar\n" \
              "o vale pallets contendo a quantidade de pallets retidos e o numero desse\n" \
              "embarque devidamente assinado e carimbado pelo cliente. \n \n" \
              "Procedendo da forma acima mencionada, ficará o motorista isento de qualquer\n" \
              "responsabilidade. O não cumprimento destas normas ou a devolução dos pallets\n" \
              "com qualquer tipo de avaria implicara o reembolso de R$ 25,00 por pallets \n" \
              "não devolvidos." \
              "\n \n \n" \
              "entregue" \
              "\n \n \n" \
              "          Assinatura do motorista:______________________________________." 

      report.page.item(:no_equipamento).value("Nº #{control.id}")
      report.page.item(:no_embarque).value("EMBARQUE: Nº #{control.boarding_id}")
      report.page.item(:notas_fiscais).value("#{control.boarding.get_number_nfe}")
      report.page.item(:text_complete).value(texto)
      
      report.page.item(:data_and_hora).value(emitido)      

      send_data report.generate, filename: "term_pallet_#{control.id}_.pdf", 
                                   type: 'application/pdf', 
                                   disposition: 'inline'
    end
end
