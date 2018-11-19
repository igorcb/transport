class ChangeStatusToTasks < ActiveRecord::Migration[5.0]
  def change
  	change_column_null(:tasks, :status, false, 0 )
  end
end
