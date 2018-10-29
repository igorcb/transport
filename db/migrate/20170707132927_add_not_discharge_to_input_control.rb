class AddNotDischargeToInputControl < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :not_discharge, :boolean, default: :false
  end
end
