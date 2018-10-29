class AddGenerateOrdemServiceToControlPallets < ActiveRecord::Migration[5.0]
  def change
    add_column :control_pallets, :generate_ordem_service, :boolean, default: false
  end
end
