class AddComprovanteToEmails < ActiveRecord::Migration[5.0]
  def change
    add_column :emails, :comprovante, :boolean
  end
end
