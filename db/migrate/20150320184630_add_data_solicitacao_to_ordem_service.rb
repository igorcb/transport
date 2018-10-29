class AddDataSolicitacaoToOrdemService < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :data_solicitacao, :date
  end
end
