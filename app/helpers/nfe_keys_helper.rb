module NfeKeysHelper

	def select_motive
		([["Divergencia de valores da nota fiscal", 1], 
			["Avaria, Sobra e ou Falta, Inversão de Mercadoria", 2], 
			["Canhoto ficou retido porque o cliente que o pagamento da mercadoria (Avaria, Sobra e ou Falta)", 3],
			["Não Houve Pagamento da Descarga", 4],
			["Motorista gerou algum dano (material) para o cliente", 5],
			["Motorista não esperou o canhoto", 6],
			["Vencimento do boleto", 7],
			["Mercadoria vencidas", 8],
			["Mercadoria com problema de produção", 9]
			])
		
	end

	def select_status_nfe_dae
		([["Aberto", 1], 
			["Pago", 2]
			])

	end
end
