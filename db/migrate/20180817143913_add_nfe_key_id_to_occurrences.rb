class AddNfeKeyIdToOccurrences < ActiveRecord::Migration
  def change
    add_reference :occurrences, :nfe_key, index: true
  end
end
