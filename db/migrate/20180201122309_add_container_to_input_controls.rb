class AddContainerToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :container, :string
  end
end
