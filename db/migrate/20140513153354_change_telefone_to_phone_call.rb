class ChangeTelefoneToPhoneCall < ActiveRecord::Migration
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
