class AddAccountReceivableToCash < ActiveRecord::Migration
  def change
    add_reference :cashes, :account_receivable, index: true
  end
end
