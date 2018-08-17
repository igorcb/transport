class AddFileOccurrenceToOccurrences < ActiveRecord::Migration
  def change
    add_reference :occurrences, :file_occurrence, index: true
  end
end
