class AddAccountReceivableToCurrentAccount < ActiveRecord::Migration
  def change
    change_table :current_accounts do |t|
		  t.references :account_receivable, index: true
	  end
  end

end
