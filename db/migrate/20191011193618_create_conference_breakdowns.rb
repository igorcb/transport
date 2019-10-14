class CreateConferenceBreakdowns < ActiveRecord::Migration[5.1]
  def change
    create_table :conference_breakdowns do |t|
      t.references :conference, foreign_key: true
      t.references :product, foreign_key: true
      t.integer :qtde

      t.timestamps
    end
  end
end
