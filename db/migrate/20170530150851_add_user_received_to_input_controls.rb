class AddUserReceivedToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :received_user_id, :integer, index: true
  end
end
