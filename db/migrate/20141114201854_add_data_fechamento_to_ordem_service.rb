class AddDataFechamentoToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :data_fechamento, :date
  end
end
