class Billing < ActiveRecord::Base
  belongs_to :type_service
  has_many :ordem_services

  module TipoStatus
  	ABERTO = 0
  	PAGO = 1
  end	

  def status_name
    case self.status
      when 0 then "Aberto"
      when 1 then "Pago"
    else "Nao Definido"
    end  	
  end
  
  def to_csv
    CSV.generate do |csv|
      csv = ordem_services.column_names
      ordem_services.each do |os|
        csv << os.attributes.values_at(*self.ordem_services.column_names)
      end
    end
  end  
end
