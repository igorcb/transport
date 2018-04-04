module DriversHelper
  def select_categoria
    ([["A","0"],["B","1"],["C","2"],["D","3"],["E","4"],["AB","5"],["AC","6"],["AD","7"],["AE","8"]])
  end

  def select_restriction
  	([["Carga", "0"],["Cliente","1"], [ "Seguradora","1"], ["Transportadora", "2"]])
  end

  def select_estado_civil
  	([
	  	["Solteiro" , "1"],
	    ["Casado comuniao universal" , "2"],
	    ["Casado comuniao parcial" , "3"],
	    ["Casado separacao de bens" , "4"],
	    ["Viuvo" , "5"],
	    ["Separado Judicialmente" , "6"],
	    ["Divorciado" , "7" ],
	    ["Casado Regime Total" , "8"]
		])
  end

  def select_cor_da_pele
  	([ ["Indigena", "1"], ["Branca", "2"], ["Preta", "4"], ["Amarela", "6"],["Parda", "8"] ])
  end

  def select_tipo_contrato
  	([
	    ["Proprio", "1"],
	    ["Proprio Pleno", "3"],
	    ["Proprio 210M", "5"],
	    ["Proprio Senior", "7"],
	    ["Terceirizado", "0"],
	    ["Terceirizado Senior", "6"],
	    ["Terceirizado Pleno", "2"],
	    ["Terceirizado 210M", "4"]
  		])
  end
end
