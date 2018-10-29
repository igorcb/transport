class CreateMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :meetings do |t|
      t.date :date_event
      t.time :time_event
      t.string :local
      t.string :summoned
      t.string :facilitator
      t.string :secretary
      t.text :objective
      t.references :created_user, foreign_key: {to_table: :users }
      t.references :updated_user, foreign_key: {to_table: :users }
      t.timestamps
    end
  end
end
