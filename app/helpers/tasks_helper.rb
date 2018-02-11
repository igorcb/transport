module TasksHelper

	def select_status
  	([["Não Iniciado", "0"],["Iniciado", "1"], ["Concluida no prazo","2"], [ "Concluida fora do prazo","3"], ["Atrasado", "4"]])
 	end
end
