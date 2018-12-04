# encoding: UTF-8
module NFe
	class IdentificacaoNFe < NFe::EntidadeNFe
    xml_name :ide
		attr_accessor :cUF
		attr_accessor :cNF
		attr_accessor :natOp
		attr_accessor :indPag
		attr_accessor :mod
		attr_accessor :serie
		attr_accessor :nNF
		attr_accessor :dhEmi
		attr_accessor :dSaiEnt
    #attr_accessor :hSaiEnt
    attr_accessor :tpNF
    attr_accessor :idDest
    attr_accessor :cMunFG
    attr_accessor :tpImp
    attr_accessor :tpEmis
    attr_accessor :cDV
    attr_accessor :tpAmb
    attr_accessor :finNFe
    attr_accessor :indFinal
    attr_accessor :indPres
    attr_accessor :procEmi
    attr_accessor :verProc
  	attr_accessor :dhCont
  	attr_accessor :xJust

    def attributes
      @attributes = {
          "cUF" => cUF,
          "cNF" => cNF,
          "natOp" => natOp,
          "indPag" => indPag,
          "mod" => mod,
          "serie" => serie,
          "nNF" => nNF,
          "dhEmi" => dhEmi,
          "dSaiEnt" => dSaiEnt,
          "tpNF" => tpNF,
          "idDest" => idDest,
          "cMunFG" => cMunFG,
          "tpImp" => tpImp,
          "tpEmis" => tpEmis,
          "cDV" => cDV,
          "tpAmb" => tpAmb,
          "finNFe" => finNFe,
          "indFinal" => indFinal,
          "indPres" => indPres,
          "procEmi" => procEmi,
          "verProc" => verProc
        }
    end

    def attributes=(params)
      @attributes = {
          "cUF" => params["cUF"],
          "cNF" => params["cNF"],
          "natOp" => params["natOp"],
          "indPag" => params["indPag"],
          "mod" => params["mod"],
          "serie" => params["serie"],
          "nNF" => params["nNF"],
          "dhEmi" => params["dhEmi"],
          "dSaiEnt" => params["dSaiEnt"],
          "tpNF" => params["tpNF"],
          "idDest" => params["idDest"],
          "cMunFG" => params["cMunFG"],
          "tpImp" => params["tpImp"],
          "tpEmis" => params["tpEmis"],
          "cDV" => params["cDV"],
          "tpAmb" => params["tpAmb"],
          "finNFe" => params["finNFe"],
          "indFinal" => params["indFinal"],
          "indPres" => params["indPres"],
          "procEmi" => params["procEmi"],
          "verProc" => params["verProc"]
        }
    end

  end
end