class AddDataSolicitacaoToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :data_solicitacao, :date
  end
end
