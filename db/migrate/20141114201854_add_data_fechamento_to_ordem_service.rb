class AddDataFechamentoToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :data_fechamento, :date
  end
end
