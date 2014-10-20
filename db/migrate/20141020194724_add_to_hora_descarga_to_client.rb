class AddToHoraDescargaToClient < ActiveRecord::Migration
  def change
    add_column :clients, :hora_descarga, :string, limit: 50
    add_column :clients, :condicao_recebimento, :text
  end
end

