class LowerAccountReceivable < ActiveRecord::Base
  belongs_to :account_receivable, required: false
  belongs_to :cash_account, required: false

  before_destroy :back_balance
  after_create :put_billing_payment

  def put_billing_payment
  	puts ">>>>>>>>> check_full: "
  	if check_full_receivable_billing?
  		puts ">>>>>>>>> Baixar Fatura: #{self.account_receivable.billing_id} "
  	  Billing.where(id: self.account_receivable.billing_id).update_all(status: Billing::TipoStatus::PAGO)
    end
  end

  def check_full_receivable_billing?
  	positivo = true
  	accounts = AccountReceivable.where(billing_id: self.account_receivable.billing_id)
    puts ">>>>>>>>>>>>>Account: #{self.account_receivable.valor.to_f}"
  	accounts.order(:id).each do |account|
  		puts ">>>>>>>>>>>>> Doc: #{account.documento} - Status: #{account.status}"
      puts ">>>>>>>>>>>>> Lower: #{account.valor.to_f}"
			positivo = account.status == AccountReceivable::TipoStatus::PAGO
			return false if positivo == false
  	end
  	positivo
  end

  private
  	def back_balance
  		ActiveRecord::Base.transaction do
  			data = Time.now.strftime('%Y-%m-%d')
  			account = self.account_receivable
  			if self.cash_account_id.present?
		      # CurrentAccount.create!(cash_account_id: self.cash_account_id,
		      #                       data: data,
		      #                       valor: self.total_pago,
		      #                       tipo: CurrentAccount::TipoLancamento::CREDITO,
		      #                       historico: "ESTORNO CONTA A PAGAR: " + account.documento,
		      #                       account_payable_id: self.id
		      #                       )
        Cash.create!(cash_account_id: self.cash_account_id,
                              data: data,
                              valor: self.total_pago,
                              tipo: Cash::TipoLancamento::DEBITO,
                              historico: "ESTORNO CONTA A PAGAR: " + self.account_receivable.documento,
                              cost_center_id: self.account_receivable.cost_center_id,
                              payment_method_id: self.account_receivable.payment_method_id,
                              sub_cost_center_id: self.account_receivable.sub_cost_center_id,
                              sub_cost_center_three_id: self.account_receivable.sub_cost_center_three_id,
                              account_receivable_id: self.account_receivable.id
                              )

	      end
  		end
  	end

end
