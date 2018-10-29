class SecondEmployeeToTasks < ActiveRecord::Migration[5.0]
  def change
  	add_reference :tasks, :second_employee, foreign_key: {to_table: :employees }
  end
end
