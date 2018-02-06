module TasksHelper

	def select_status
  	([["Não Iniciado", "0"],["Concluida no prazo","1"], [ "Concluida fora do prazo","1"], ["Atrasado", "2"]])
 	end
end
