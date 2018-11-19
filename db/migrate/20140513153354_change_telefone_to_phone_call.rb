class ChangeTelefoneToPhoneCall < ActiveRecord::Migration[5.0]
def self.up
    change_table :phone_calls do |t|
      t.change :telefone, :string, limit: 50, null: false
    end
  end
  def self.down
    change_table :phone_calls do |t|
      t.change :telefone, :string, limit: 10, null: false
    end
  end
end
