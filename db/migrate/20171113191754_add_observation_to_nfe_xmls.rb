class AddObservationToNfeXmls < ActiveRecord::Migration
  def change
    add_column :nfe_xmls, :observation, :text
  end
end
