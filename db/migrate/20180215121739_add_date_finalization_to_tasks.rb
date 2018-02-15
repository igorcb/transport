class AddDateFinalizationToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :date_finalization, :datetime
  end
end
