class ModifyDefaultToPallet < ActiveRecord::Migration[5.0]
  def up
    execute "ALTER TABLE pallets ALTER COLUMN data_agendamento DROP NOT NULL"
    execute "ALTER TABLE pallets ALTER COLUMN qtde DROP NOT NULL"
  end
  
  def down
    execute "ALTER TABLE pallets ALTER COLUMN data_agendamento SET NOT NULL"
    execute "ALTER TABLE pallets ALTER COLUMN qtde SET NOT NULL"
  end
end
