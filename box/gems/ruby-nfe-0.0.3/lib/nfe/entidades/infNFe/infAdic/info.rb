# encoding: UTF-8
module NFe
	class Info < NFe::EntidadeNFe
    xml_name :infAdic
		attr_accessor :infCpl

    def attributes
      @attributes = {
          "infCpl" => infCpl
        }
    end

    def attributes=(params)
      @attributes = {
          "infCpl" => params["infCpl"]
        }
    end

  end
end