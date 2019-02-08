class AddDoorsToCheckins < ActiveRecord::Migration[5.1]
  def change
    add_column :checkins, :door, :integer
  end
end
