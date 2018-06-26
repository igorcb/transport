class SecondEmployeeToTasks < ActiveRecord::Migration
  def change
  	add_reference :tasks, :second_employee, foreign_key: {to_table: :employee }
  end
end
