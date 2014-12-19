class PaymentMethod < ActiveRecord::Base

  has_many :account_payables
  
  before_destroy :can_destroy?

  private 
    def can_destroy?
      if self.account_payables.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end    	
end
