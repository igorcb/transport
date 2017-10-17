class AddActionInspectorToBoardings < ActiveRecord::Migration
  def change
    add_column :boardings, :action_inspector, :string, limit: 20
  end
end
