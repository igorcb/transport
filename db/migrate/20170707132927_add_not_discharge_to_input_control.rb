class AddNotDischargeToInputControl < ActiveRecord::Migration
  def change
    add_column :input_controls, :not_discharge, :boolean, default: :false
  end
end
