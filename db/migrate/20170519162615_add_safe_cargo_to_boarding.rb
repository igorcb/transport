class AddSafeCargoToBoarding < ActiveRecord::Migration
  def change
    add_column :boardings, :safe_rctr_c, :decimal, precision: 20, scale: 4
    add_column :boardings, :safe_optional, :decimal, precision: 20, scale: 4
  end
end
