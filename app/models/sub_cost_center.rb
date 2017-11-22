class SubCostCenter < ActiveRecord::Base
  validates :descricao, presence: true, uniqueness: { scope: :cost_center }

  belongs_to :cost_center
  belongs_to :type_service
  has_many :account_payables
  has_many :sub_cost_center_threes
  
  before_destroy :can_destroy?

  def valor_total
    self.account_payables.sum(:valor)
  end

  def total_pago
    valor = 0
    account_payables = AccountPayable.where(sub_cost_center_id: self.id)
    account_payables.each do |account|
      valor += account.total_pago
    end
    valor
  end

  def total_aberto
    valor_total - total_pago
  end

  private 
    def can_destroy?
      if self.account_payables.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end    
end
