class AddInputControlToAccountReceivable < ActiveRecord::Migration
  def change
    add_reference :account_receivables, :input_control, index: true
    add_column :account_receivables, :type_account, :integer, default: 3
    add_column :account_receivables, :client_type, :string, default: 'Client'
  end
end
