class CreateEdiQueues < ActiveRecord::Migration[5.1]
  def change
    create_table :edi_queues do |t|
      t.references :nfe_key, foreign_key: true
      t.integer :status, defaut: 0

      t.timestamps
    end
  end
end
