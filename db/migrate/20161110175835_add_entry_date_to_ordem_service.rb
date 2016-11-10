class AddEntryDateToOrdemService < ActiveRecord::Migration
  def change
    add_column :ordem_services, :date_entry, :date
  end
end
