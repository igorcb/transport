class AddFileOccurrenceToOccurrences < ActiveRecord::Migration[5.0]
  def change
    add_reference :occurrences, :file_occurrence, index: true
  end
end
