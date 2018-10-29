class AddObsToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :obs, :text
  end
end
