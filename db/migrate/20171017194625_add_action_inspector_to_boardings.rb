class AddActionInspectorToBoardings < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :action_inspector, :string, limit: 20
  end
end
