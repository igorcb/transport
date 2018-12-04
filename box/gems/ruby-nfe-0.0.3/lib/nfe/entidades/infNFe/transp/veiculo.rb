# encoding: UTF-8

module NFe
	class Veiculo < NFe::EntidadeNFe
    xml_name :veicTransp
		attr_accessor :placa
		attr_accessor :UF
		
    # attr_accessor :RNTC
    # "RNTC" => RCNT
		# "RNTC" => params["RNTC"]

    def attributes
      @attributes = {
          "placa" => placa,
          "UF" => UF
        }
    end

    def attributes=(params)
      @attributes = {
          "placa" => params["placa"],
          "UF" => params["UF"]
        }
    end

  end
end