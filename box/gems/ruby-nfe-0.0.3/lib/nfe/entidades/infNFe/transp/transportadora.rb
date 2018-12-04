# encoding: UTF-8
module NFe
	class Transportadora < NFe::EntidadeNFe
    xml_name :transporta
		attr_accessor :CNPJ
		attr_accessor :xNome
		attr_accessor :IE
		attr_accessor :xEnder
		attr_accessor :xMun
		attr_accessor :UF

    def attributes
      @attributes = {
          "CNPJ" => CNPJ,
          "xNome" => xNome,
          "IE" => IE,
          "xEnder" => xEnder,
          "xMun" => xMun,
          "UF" => UF
        }
    end

    def attributes=(params)
      @attributes = {
          "CNPJ" => params["CNPJ"],
          "xNome" => params["xNome"],
          "IE" => params["IE"],
          "xEnder" => params["xEnder"],
          "xMun" => params["xMun"],
          "UF" => params["UF"]
        }
    end

  end
end