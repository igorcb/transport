class AddBillingIdToOrdemService < ActiveRecord::Migration
  def change
    add_reference :ordem_services, :billing, index: true
  end
end
