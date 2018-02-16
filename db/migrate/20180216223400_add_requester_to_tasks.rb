class AddRequesterToTasks < ActiveRecord::Migration
  def change
    add_column :tasks, :requester_id, :integer
  end
end
