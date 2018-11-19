class AddBillingClientIdToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :billing_client_id, :integer
  end
end
