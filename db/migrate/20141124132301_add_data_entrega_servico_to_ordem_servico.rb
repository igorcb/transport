class AddDataEntregaServicoToOrdemServico < ActiveRecord::Migration
  def change
    add_column :ordem_services, :data_entrega_servico, :date
  end
end
