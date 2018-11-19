class AddTakeDaeToNfeXmls < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_xmls, :take_dae, :boolean
  end
end
