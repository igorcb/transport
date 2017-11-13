class AddObservationToNfeKeys < ActiveRecord::Migration
  def change
    add_column :nfe_keys, :observation, :text
  end
end
