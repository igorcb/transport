class CreateActionInspectors < ActiveRecord::Migration
  def change
    create_table :action_inspectors do |t|
      t.references :input_control, index: true
      t.string :number
      t.attachment :asset
      t.references :user_confirmed, foreign_key: {to_table: :users }
      t.timestamp :updated_confirmed

      t.timestamps
    end
  end
end
