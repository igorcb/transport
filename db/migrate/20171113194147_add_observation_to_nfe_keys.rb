class AddObservationToNfeKeys < ActiveRecord::Migration[5.0]
  def change
    add_column :nfe_keys, :observation, :text
  end
end
