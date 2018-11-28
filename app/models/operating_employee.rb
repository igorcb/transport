class OperatingEmployee < ActiveRecord::Base
  belongs_to :operating, required: false
  belongs_to :employee, required: false

  def valor_total
  	valor_diaria + valor_almoco + valor_transporte + valor_extra
  end
end
