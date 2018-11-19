class CreateSubjects < ActiveRecord::Migration[5.0]
  def change
    create_table :subjects do |t|
      t.references :meeting, index: true
      t.string :title
      t.time :time_meeting
      t.string :responsible
      t.references :created_user, foreign_key: {to_table: :users }
      t.references :updated_user, foreign_key: {to_table: :users }
      
      t.timestamps
    end
  end
end
