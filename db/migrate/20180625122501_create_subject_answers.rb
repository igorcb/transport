class CreateSubjectAnswers < ActiveRecord::Migration[5.0]
  def change
    create_table :subject_answers do |t|
      t.references :subject, index: true
      t.date :deadline
      t.string :responsible
      t.text :action
      t.references :created_user, foreign_key: {to_table: :users }
      t.references :updated_user, foreign_key: {to_table: :users }
      
      t.timestamps
    end
  end
end
