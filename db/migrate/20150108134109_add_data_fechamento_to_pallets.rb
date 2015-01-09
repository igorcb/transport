class AddDataFechamentoToPallets < ActiveRecord::Migration
  def change
    add_column :pallets, :data_fechamento, :date
  end
end
