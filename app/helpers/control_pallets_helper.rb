module ControlPalletsHelper

	def select_credito_debito_pallets
    ([['Saida', -1], ['Entrada', 1]])
  end

	def select_select_responsible
	  ([['Client', 0], ['Motorista', 1], ['Transportadora', 2]])
	end
end
