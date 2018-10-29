class AddBillingIdToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_reference :ordem_services, :billing, index: true
  end
end
