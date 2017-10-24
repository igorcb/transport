class AddDirectChargeToOfferCharges < ActiveRecord::Migration
  def change
    add_reference :offer_charges, :direct_charge, index: true
  end
end
