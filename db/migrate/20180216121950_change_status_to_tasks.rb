class ChangeStatusToTasks < ActiveRecord::Migration
  def change
  	change_column_null(:tasks, :status, false, 0 )
  end
end
