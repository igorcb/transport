class ChangeChargeDischargeToInputControl < ActiveRecord::Migration[5.0]
  def change
  	change_column_default :input_controls, :charge_discharge, true
  end
end
