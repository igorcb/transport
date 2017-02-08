class LowerAccountPayable < ActiveRecord::Base
  belongs_to :account_payable
	belongs_to :cash_account
  has_many :assets, as: :asset, dependent: :destroy
  accepts_nested_attributes_for :assets, allow_destroy: true, reject_if: :all_blank

  before_destroy :back_balance

  private
  	def back_balance
  		ActiveRecord::Base.transaction do
  			data = Time.now.strftime('%Y-%m-%d')
  			account = self.account_payable
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
                              tipo: Cash::TipoLancamento::CREDITO,
                              historico: "ESTORNO CONTA A PAGAR: " + self.account_payable.documento,
                              cost_center_id: self.account_payable.cost_center_id,
                              payment_method_id: self.account_payable.payment_method_id,
                              sub_cost_center_id: self.account_payable.sub_cost_center_id,
                              sub_cost_center_three_id: self.account_payable.sub_cost_center_three_id,
                              account_payable_id: self.id
                              )

	      end
  		end
  	end

end
