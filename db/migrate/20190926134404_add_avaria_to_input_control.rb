class AddAvariaToInputControl < ActiveRecord::Migration[5.1]
  # def change
  #   add_column :input_controls, :avaria, :boolean
  #   add_column :input_controls, :date_start_avaria, :date
  #   add_column :input_controls, :date_finish_avaria, :date
  #   add_column :input_controls, :time_start_avaria, :time
  #   add_column :input_controls, :time_finish_avaria, :time
  # end

  def self.up
      add_column :input_controls, :date_start_avaria, :date
      add_column :input_controls, :date_finish_avaria, :date
      add_column :input_controls, :time_start_avaria, :time
      add_column :input_controls, :time_finish_avaria, :time
  end

  def self.down
    remove_column :input_controls, :date_start_avaria, :timestamp
    remove_column :input_controls, :date_finish_avaria, :timestamp
  end
end
