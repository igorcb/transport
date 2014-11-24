class ModifyDataToOrdemServico < ActiveRecord::Migration
  def up
  	change_column :ordem_services, :data, :date, null: true
  end

  def down
  	change_column :ordem_services, :data, :date, null: false
  end
end
