class CreateCancellations < ActiveRecord::Migration
  def change
    create_table :cancellations do |t|
      t.integer :solicitation_user_id
      t.integer :authorization_user_id
      t.integer :status
      t.text :observacao
      t.references :cancel, polymorphic: true, index: true

      t.timestamps
    end
  end
end
