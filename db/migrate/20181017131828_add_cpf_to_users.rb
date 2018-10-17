class AddCpfToUsers < ActiveRecord::Migration
  def change
    add_column :users, :active, :string
    add_column :users, :cpf, :string
    add_column :users, :name, :string
    add_reference :users, :employee, index: true
  end
end
