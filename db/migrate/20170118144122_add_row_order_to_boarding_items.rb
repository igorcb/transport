class AddRowOrderToBoardingItems < ActiveRecord::Migration
  def change
		add_column :boarding_items, :row_order, :integer
  end
end
