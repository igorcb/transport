class AddDateReceiptAtToSchedulings < ActiveRecord::Migration
  def change
    add_column :schedulings, :date_receipt_at, :datetime
  end
end
