class AddRowOrderToBoardingItems < ActiveRecord::Migration[5.0]
  def change
		add_column :boarding_items, :row_order, :integer
  end
end
