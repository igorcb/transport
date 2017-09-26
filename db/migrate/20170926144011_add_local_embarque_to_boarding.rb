class AddLocalEmbarqueToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :local_embarque, :integer
  end
end
