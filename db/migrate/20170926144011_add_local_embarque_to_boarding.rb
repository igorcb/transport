class AddLocalEmbarqueToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :local_embarque, :integer
  end
end
