class CreateCancellations < ActiveRecord::Migration
  def change
    create_table :cancellations do |t|
      t.integer :solicitation_user_id
      t.integer :authorization_user_id
      t.integer :status, null: false, default: 0
      t.text :observacao
      t.references :cancellation, polymorphic: true, index: true

      t.timestamps
    end
  end
end
