class AddRowOrderToLinks < ActiveRecord::Migration
  def change
    add_column :links, :row_order, :integer
  end
end
