class AddBillingClientToInputControls < ActiveRecord::Migration[5.0]
  def change
    add_column :input_controls, :billing_client_id, :integer, index: true
  end
end
