class AddBillingClientToClientRepresentatives < ActiveRecord::Migration
  def change
    add_column :client_representatives, :billing_client_id, :integer, index: true
  end
end
