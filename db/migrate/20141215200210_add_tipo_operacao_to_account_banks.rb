class AddTipoOperacaoToAccountBanks < ActiveRecord::Migration[5.0]
  def change
    add_column :account_banks, :tipo_operacao, :integer
  end
end
