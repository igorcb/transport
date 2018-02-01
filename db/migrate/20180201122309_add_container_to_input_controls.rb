class AddContainerToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :container, :string
  end
end
