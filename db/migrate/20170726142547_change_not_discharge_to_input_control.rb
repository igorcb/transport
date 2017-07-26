class ChangeNotDischargeToInputControl < ActiveRecord::Migration
  def change
  	rename_column :input_controls, :not_discharge, :charge_discharge
  end
end
