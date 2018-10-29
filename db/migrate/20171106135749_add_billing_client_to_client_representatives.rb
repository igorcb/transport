class AddBillingClientToClientRepresentatives < ActiveRecord::Migration[5.0]
  def change
    add_column :client_representatives, :billing_client_id, :integer, index: true
  end
end
