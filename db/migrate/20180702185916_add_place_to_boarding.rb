class AddPlaceToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :place, :string
    add_column :boardings, :qtde_pallets_shipped, :integer
  end
end
