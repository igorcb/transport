class LowerReceivablesController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper

	before_action :set_lower_receivable, only: [:destroy, :quitter]

  def destroy
		@account_receivable = AccountReceivable.find(@lower.account_receivable)
		@lower.destroy
		@account_receivable.check_balance
    respond_to do |format|
      format.html { redirect_to account_receivable_path(@account_receivable) }
      format.json { head :no_content }
    end		
	end

  def quitter
    respond_to do |format|
      format.pdf { render_quitter(@lower) }
    end
  end

  private
    def set_lower_receivable
      @lower = LowerAccountReceivable.find(params[:id])
    end

    def render_quitter(quitter)
      report = ThinReports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'recibo.tlf')
      @company = Company.first
      src_image = @company.image.path
      valor = (quitter.total_pago.to_f * 100).to_i
      local_data = "FORTALEZA, #{l quitter.data_pagamento , format: :long }"
      report.start_new_page
      
      #report.page.item(:image_logo).src('/path/to/image.png')
      report.page.item(:image_logo).src(@company.image.path) #@company.image.url
      report.page.item(:image_quitter).src(@company.quitter.path) #@company.image.url
      report.page.item(:emp_fantasia).value(@company.fantasia)
      report.page.item(:emp_razao_social).value(@company.razao_social)
      report.page.item(:emp_cnpj).value("CNPJ: " + @company.cnpj)
      report.page.item(:emp_fone).value("CONTATO: " + @company.phone_first)
      report.page.item(:emp_cidade).value(@company.cidade_estado)

      report.page.item(:valor_numerico).value("R$ #{number_to_currency(quitter.total_pago, precision: 2, unit: "", separator: ",", delimiter: ".")}")
      report.page.item(:nome).value(quitter.account_receivable.client.nome)
      report.page.item(:cpf_cnpj).value(quitter.account_receivable.client.cpf)
      report.page.item(:valor_extenso).value(Extenso.moeda(valor))
      report.page.item(:account_obs).value(quitter.account_receivable.observacao)
      report.page.item(:issue_date).value(local_data)
      send_data report.generate, filename: "recibo_#{quitter.id}_.pdf", 
                                   type: 'application/pdf', 
                                   disposition: 'inline'

    end


end
