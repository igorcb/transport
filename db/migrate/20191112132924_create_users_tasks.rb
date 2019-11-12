class CreateUsersTasks < ActiveRecord::Migration[5.1]
  def change
    create_table(:users_tasks) do |t|
      t.references :user
      t.references :task
    end

    add_index(:users_tasks, [ :user_id, :task_id ])
  end
end
