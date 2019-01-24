class AddPlacesToCheckins < ActiveRecord::Migration[5.1]
  def change
    add_column :checkins, :place_horse, :string
    add_column :checkins, :place_cart_1, :string
    add_column :checkins, :place_cart_2, :string
  end
end
