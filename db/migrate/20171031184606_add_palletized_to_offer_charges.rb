class AddPalletizedToOfferCharges < ActiveRecord::Migration
  def change
    add_column :offer_charges, :palletized, :boolean
  end
end
