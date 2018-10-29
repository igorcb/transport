class AddPalletizedToOfferCharges < ActiveRecord::Migration[5.0]
  def change
    add_column :offer_charges, :palletized, :boolean
  end
end
