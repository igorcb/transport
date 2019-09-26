class AddDeclinedToBoarding < ActiveRecord::Migration[5.1]
  def change
    add_column :boardings, :declined, :integer, default: 0
  end

  def data
    Boarding.update_all(declined: 0)
  end
end
