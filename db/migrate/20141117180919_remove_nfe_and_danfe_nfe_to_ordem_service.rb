class RemoveNfeAndDanfeNfeToOrdemService < ActiveRecord::Migration[5.0]
  def change
  	remove_column :ordem_services, :nfe, :string
  	remove_column :ordem_services, :danfe_nfe, :string
  end
end
