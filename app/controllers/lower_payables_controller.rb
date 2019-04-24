class LowerPayablesController < ApplicationController
  def destroy
		@lower = LowerAccountPayable.find(params[:id])
		@account_payable = AccountPayable.find(@lower.account_payable)
		@lower.destroy
		@account_payable.check_balance
    respond_to do |format|
      format.html { redirect_to account_payable_path(@account_payable) }
      format.json { head :no_content }
    end
	end

  def quitter
    @lower = LowerAccountPayable.find(params[:id])
    respond_to do |format|
      format.pdf { render_quitter_discharge_payment(@lower) }
    end
  end

  private
    def set_lower_receivable
      @lower = LowerAccountPayable.find(params[:id])
    end

    def render_quitter_discharge_payment(lower)
      report = Thinreports::Report.new layout: File.join(Rails.root, 'app', 'reports', 'quitter_discharge_payment.tlf')
      @company = Company.first
      src_image = @company.image.path
      valor = (lower.account_payable.total_pago.to_f * 100).to_i
       local_data = "FORTALEZA, #{l lower.data_pagamento , format: :long }"
      report.start_new_page

      #report.page.item(:image_logo).src('/path/to/image.png')
      report.page.item(:image_logo).src(@company.image.path) #@company.image.url
      report.page.item(:image_quitter).src(@company.quitter.path) #@company.image.url
      report.page.item(:emp_fantasia).value(@company.fantasia)
      report.page.item(:emp_razao_social).value(@company.razao_social)
      report.page.item(:emp_cnpj).value("CNPJ: " + @company.cnpj)
      report.page.item(:emp_fone).value("CONTATO: " + @company.phone_first)
      report.page.item(:emp_cidade).value(@company.cidade_estado)

      report.page.item(:valor_numerico).value("R$ #{number_to_currency(lower.total_pago, precision: 2, unit: "", separator: ",", delimiter: ".")}")
      report.page.item(:nome).value(lower.account_payable.supplier.nome)
      report.page.item(:cpf_cnpj).value(lower.account_payable.supplier.cpf)
      report.page.item(:valor_extenso).value(Extenso.moeda(valor))
      report.page.item(:account_obs).value(lower.account_payable.observacao)
      
      report.page.item(:issue_date).value(local_data)
      send_data report.generate, filename: "recibo_#{lower.id}_.pdf",
                                   type: 'application/pdf',
                                   disposition: 'inline'


    end
end
