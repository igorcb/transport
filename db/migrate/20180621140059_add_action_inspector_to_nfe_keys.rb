class AddActionInspectorToNfeKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :action_inspector_number, :string
    add_attachment :nfe_keys, :action_inspector
    add_reference :nfe_keys, :action_inspector_user_confirmed, foreign_key: {to_table: :users }
    add_column :nfe_keys, :action_inspector_updated_confirmed, :timestamp
    add_column :nfe_keys, :take_dae, :boolean
  end
end
