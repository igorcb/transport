class Historic < ActiveRecord::Base
  has_many :account_payables

  before_destroy :can_destroy?

  def self.historic_default
    conf = ConfigSystem.where(config_key: 'HISTORIC_DEFAULT').first
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
