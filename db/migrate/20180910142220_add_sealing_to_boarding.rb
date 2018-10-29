class AddSealingToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :sealing, :string
    add_column :boardings, :sealing_two, :string
    add_column :boardings, :sealing_three, :string
  end
end
