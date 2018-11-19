class AddRowOrderToLinks < ActiveRecord::Migration[5.0]
  def change
    add_column :links, :row_order, :integer
  end
end
