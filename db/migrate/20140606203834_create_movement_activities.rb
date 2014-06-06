class CreateMovementActivities < ActiveRecord::Migration
  def change
    create_table :movement_activities do |t|
      t.references :supplier, index: true
      t.references :activity, index: true
      t.integer :movement_activity_id
      t.string :movement_activity_type

      t.timestamps
    end
  end
end
