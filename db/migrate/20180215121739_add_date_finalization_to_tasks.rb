class AddDateFinalizationToTasks < ActiveRecord::Migration[5.0]
  def change
    add_column :tasks, :date_finalization, :datetime
  end
end
