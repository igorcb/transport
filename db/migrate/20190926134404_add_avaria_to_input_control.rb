class AddAvariaToInputControl < ActiveRecord::Migration[5.1]
  def change
    add_column :input_controls, :avaria, :boolean
    add_column :input_controls, :date_start_avaria, :datetime
    add_column :input_controls, :date_finish_avaria, :datetime
  end
end
