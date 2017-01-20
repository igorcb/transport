class AddObsToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :obs, :text
  end
end
