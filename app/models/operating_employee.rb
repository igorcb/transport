class OperatingEmployee < ActiveRecord::Base
  belongs_to :operating
  belongs_to :employee

  def valor_total
  	valor_diaria + valor_almoco + valor_transporte + valor_extra
  end
end
