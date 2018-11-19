class ChangeNotDischargeToInputControl < ActiveRecord::Migration[5.0]
  def change
  	rename_column :input_controls, :not_discharge, :charge_discharge
  end
end
