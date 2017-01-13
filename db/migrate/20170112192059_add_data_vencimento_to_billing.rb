class AddDataVencimentoToBilling < ActiveRecord::Migration
  def change
    add_column :billings, :data_vencimento, :date, index: true
  end
end
