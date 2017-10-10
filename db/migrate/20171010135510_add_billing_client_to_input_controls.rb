class AddBillingClientToInputControls < ActiveRecord::Migration
  def change
    add_column :input_controls, :billing_client_id, :integer, index: true
  end
end
