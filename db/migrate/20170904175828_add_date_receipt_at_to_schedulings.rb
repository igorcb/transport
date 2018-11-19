class AddDateReceiptAtToSchedulings < ActiveRecord::Migration[5.0]
  def change
    add_column :schedulings, :date_receipt_at, :datetime
  end
end
