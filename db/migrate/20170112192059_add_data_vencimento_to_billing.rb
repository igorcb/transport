class AddDataVencimentoToBilling < ActiveRecord::Migration[5.0]
  def change
    add_column :billings, :data_vencimento, :date, index: true
  end
end
