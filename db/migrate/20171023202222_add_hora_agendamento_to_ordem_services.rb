class AddHoraAgendamentoToOrdemServices < ActiveRecord::Migration
  def change
    add_column :ordem_services, :hora_agendamento, :time
  end
end
