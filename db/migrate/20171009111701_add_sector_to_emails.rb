class AddSectorToEmails < ActiveRecord::Migration
  def change
    add_reference :emails, :sector, index: true
  end
end
