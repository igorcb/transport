class AddHoraAgendamentoToOrdemServices < ActiveRecord::Migration[5.0]
  def change
    add_column :ordem_services, :hora_agendamento, :time
  end
end
