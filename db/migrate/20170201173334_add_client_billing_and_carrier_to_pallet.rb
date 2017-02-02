class AddClientBillingAndCarrierToPallet < ActiveRecord::Migration
  def change
    add_column :pallets, :billing_client_id, :integer, index: true
    add_reference :pallets, :carrier, index: true
  end
end
