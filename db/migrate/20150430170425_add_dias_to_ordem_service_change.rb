class AddDiasToOrdemServiceChange < ActiveRecord::Migration
  def change
    add_column :ordem_service_changes, :dias, :integer, default: 0
  end
end
