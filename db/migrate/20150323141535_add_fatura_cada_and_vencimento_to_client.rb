class AddFaturaCadaAndVencimentoToClient < ActiveRecord::Migration[5.0]
  def change
    add_column :clients, :faturar_cada, :integer
    add_column :clients, :vencimento_para, :integer
  end
end
