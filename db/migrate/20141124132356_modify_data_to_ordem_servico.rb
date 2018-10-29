class ModifyDataToOrdemServico < ActiveRecord::Migration[5.0]
  def up
  	change_column :ordem_services, :data, :date, null: true
  end

  def down
  	change_column :ordem_services, :data, :date, null: false
  end
end
