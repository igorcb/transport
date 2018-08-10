module ClientsHelper
  def select_tipo_cliente
    ([["Normal", 0], ["Especial", 1]])
  end	

  def select_type_height_maximum_pallet
  	([["Padrao do Fabricante", 0], 
  		["Padrao do Cliente", 1],
  		["Padrao do Cliente e Produto", 2]
  	])
  	
  end
end
