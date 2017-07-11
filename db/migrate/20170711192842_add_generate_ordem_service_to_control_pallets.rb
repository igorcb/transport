class AddGenerateOrdemServiceToControlPallets < ActiveRecord::Migration
  def change
    add_column :control_pallets, :generate_ordem_service, :boolean
  end
end
