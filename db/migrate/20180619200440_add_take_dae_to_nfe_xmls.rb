class AddTakeDaeToNfeXmls < ActiveRecord::Migration
  def change
    add_column :nfe_xmls, :take_dae, :boolean
  end
end
