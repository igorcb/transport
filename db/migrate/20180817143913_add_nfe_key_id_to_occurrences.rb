class AddNfeKeyIdToOccurrences < ActiveRecord::Migration[5.0]
  def change
    add_reference :occurrences, :nfe_key, index: true
  end
end
