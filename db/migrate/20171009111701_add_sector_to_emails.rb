class AddSectorToEmails < ActiveRecord::Migration[5.0]
  def change
    add_reference :emails, :sector, index: true
  end
end
