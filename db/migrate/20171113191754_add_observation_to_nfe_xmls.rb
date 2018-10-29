class AddObservationToNfeXmls < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_xmls, :observation, :text
  end
end
