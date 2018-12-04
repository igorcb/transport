# encoding: UTF-8
module NFe
	class InfoProtocolo < NFe::EntidadeNFe
    xml_name :infProt
		attr_accessor :tpAmb
    attr_accessor :verAplic
    attr_accessor :chNFe
    attr_accessor :dhRecbto
    attr_accessor :nProt
    attr_accessor :digVal
    attr_accessor :cStat
    attr_accessor :xMotivo

    def attributes
      @attributes = {
          "tpAmb" => tpAmb,
          "verAplic" => verAplic,
          "chNFe" => chNFe,
          "dhRecbto" => dhRecbto,
          "nProt" => nProt,
          "cStat" => cStat,
          "xMotivo" => xMotivo
        }
    end

    def attributes=(params)
      @attributes = {
          "tpAmb" => params["tpAmb"],
          "verAplic" => params["verAplic"],
          "chNFe" => params["chNFe"],
          "dhRecbto" => params["dhRecbto"],
          "nProt" => params["nProt"],
          "cStat" => params["cStat"],
          "xMotivo" => params["xMotivo"]
        }
    end

  end
end