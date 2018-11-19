class AddDataEntregaServicoToOrdemServico < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :data_entrega_servico, :date
  end
end
