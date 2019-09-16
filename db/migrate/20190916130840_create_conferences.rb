class CreateConferences < ActiveRecord::Migration[5.1]
  def change
    create_table :conferences do |t|
      t.string :type_operation
      t.references :conference, polymorphic: true, index: true
      t.date :date_conference
      t.time :start_time
      t.string :finish_time
      t.string :status
      t.boolean :approved
      t.references :user, foreign_key: true

      t.timestamps
    end
  end
end
