# encoding: UTF-8
module NFe
	class Volume < NFe::EntidadeNFe
    xml_name :vol
		attr_accessor :qVol
		attr_accessor :esp
		attr_accessor :pesoL
		attr_accessor :pesoB

    def attributes
      @attributes = {
          "qVol" => qVol,
          "esp" => esp,
          "pesoL" => pesoL,
          "pesoB" => pesoB
        }
    end

    def attributes=(params)
      @attributes = {
          "qVol" => params["qVol"],
          "esp" => params["esp"],
          "pesoL" => params["pesoL"],
          "pesoB" => params["pesoB"]
        }
    end

  end
end