class ChangeChargeDischargeToInputControl < ActiveRecord::Migration
  def change
  	change_column_default :input_controls, :charge_discharge, true
  end
end
