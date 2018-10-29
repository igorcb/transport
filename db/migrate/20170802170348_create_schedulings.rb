class CreateSchedulings < ActiveRecord::Migration[5.0]
  def change
    create_table :schedulings do |t|
      t.string :client, limit: 50
      t.string :type_modal
      t.date :date_scheduling
      t.time :time_scheduling
      t.date :date_scheduling_client
      t.time :time_scheduling_client

      t.timestamps
    end
  end
end
