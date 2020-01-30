class AddTypeSelectResponsibleToControlPallets < ActiveRecord::Migration[5.1]
  def change
    add_column :control_pallets, :type_select_responsible, :integer
  end
end
