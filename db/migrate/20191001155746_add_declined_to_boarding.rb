class AddDeclinedToBoarding < ActiveRecord::Migration[5.1]
  def change
    add_column :boardings, :declined, :integer
  end
end
