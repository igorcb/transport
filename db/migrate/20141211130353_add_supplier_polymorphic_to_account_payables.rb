class AddSupplierPolymorphicToAccountPayables < ActiveRecord::Migration[5.0]
  def change
  	add_column :account_payables, :type_account, :integer
  	add_column :account_payables, :supplier_type, :string
  	AccountPayable.update_all(type_account: 0, supplier_type: "Supplier")
  end
end
