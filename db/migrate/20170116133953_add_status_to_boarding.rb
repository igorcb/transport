class AddStatusToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :status, :integer
  end
end
