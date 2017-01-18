class AddStatusToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :status, :integer
  end
end
