class CreateEvents < ActiveRecord::Migration[5.0]
  def change
    create_table :events do |t|
      t.references :user, index: true
      t.string :controller_name
      t.string :action_name
      t.text :what

      t.timestamps
    end
  end
end
