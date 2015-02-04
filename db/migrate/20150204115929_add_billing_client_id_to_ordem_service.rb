class AddBillingClientIdToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :billing_client_id, :integer
  end
end
