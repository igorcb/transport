class AddSealingToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :sealing, :string
    add_column :boardings, :sealing_two, :string
    add_column :boardings, :sealing_three, :string
  end
end
