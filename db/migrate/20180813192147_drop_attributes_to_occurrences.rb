class DropAttributesToOccurrences < ActiveRecord::Migration[5.0]
  def up
  	remove_index :occurrences, name: :index_occurrences_on_driver_id
  	remove_column :occurrences, :driver_id
  	remove_column :occurrences, :placa
  	remove_column :occurrences, :cte
  	remove_column :occurrences, :data

		add_column :occurrences, :date_occurrence, :date
  	add_column :occurrences, :number_nfe, :string
  	add_column :occurrences, :motive_id, :integer
  	add_column :occurrences, :observation, :text
  end

  def down
  	add_index :occurrences, :driver_id, name: 'index_occurrences_on_driver_id'

  	add_column :occurrences, :driver_id, :integer
  	add_column :occurrences, :placa, :string
  	add_column :occurrences, :cte, :string
  	add_column :occurrences, :data, :date

  	remove_column :occurrences, :number_nfe
  	remove_column :occurrences, :motive_id
  	remove_column :occurrences, :observation
  end
end

