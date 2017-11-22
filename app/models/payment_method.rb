class PaymentMethod < ActiveRecord::Base
  validates :descricao, presence: true, uniqueness: true
  
  has_many :account_payables
  
  before_destroy :can_destroy?

  def self.payment_method_default
    conf = ConfigSystem.where(config_key: 'PAYMENT_METHOD_DEFAULT').first
    conf.config_value.to_i
  end

  private 
    def can_destroy?
      if self.account_payables.present?
        errors.add(:base, "You can not delete record with relationship") 
        return false
      end
    end    	
end
