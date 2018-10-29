class CreateTasks < ActiveRecord::Migration[5.0]
  def change
    create_table :tasks do |t|
      t.references :employee, index: true
      t.string :name
      t.text :body
      t.date :start_date
      t.date :finish_date
      t.integer :time_first
      t.integer :allocated
      t.text :allocated_observation
      t.integer :second_time
      t.integer :status
      t.text :observation

      t.timestamps
    end
  end
end
