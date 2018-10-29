class AddDataFechamentoToPallets < ActiveRecord::Migration[5.0]
  def change
    add_column :pallets, :data_fechamento, :date
  end
end
