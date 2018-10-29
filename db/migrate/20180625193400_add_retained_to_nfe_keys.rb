class AddRetainedToNfeKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :retained, :integer, default: 0
    add_column :nfe_keys, :motive_id, :integer
    add_column :nfe_keys, :motive_observation, :text
    add_reference :nfe_keys, :retained_created_user, foreign_key: {to_table: :users }
  end
end