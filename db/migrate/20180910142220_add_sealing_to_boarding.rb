class AddSealingToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :sealing, :string
  end
end
