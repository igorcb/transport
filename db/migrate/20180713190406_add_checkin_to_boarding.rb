class AddCheckinToBoarding < ActiveRecord::Migration[5.0]
  def change
    add_column :boardings, :driver_checkin, :boolean, default: false
    add_column :boardings, :driver_checkin_palce_horse, :string
    add_column :boardings, :driver_checkin_palce_cart_1, :string
    add_column :boardings, :driver_checkin_palce_cart_2, :string
    add_column :boardings, :driver_checkin_time, :datetime
    add_reference :boardings, :driver_checkin_user, foreign_key: {to_table: :users }  
  end
end
