class AddComprovanteToEmails < ActiveRecord::Migration
  def change
    add_column :emails, :comprovante, :boolean
  end
end
