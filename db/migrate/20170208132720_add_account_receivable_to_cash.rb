class AddAccountReceivableToCash < ActiveRecord::Migration[5.0]
  def change
    add_reference :cashes, :account_receivable, index: true
  end
end
