class AddToQtdeInformadaToPallet < ActiveRecord::Migration
  def change
    add_column :pallets, :qtde_informada, :integer
    add_column :pallets, :data_informada, :date
  end
end
