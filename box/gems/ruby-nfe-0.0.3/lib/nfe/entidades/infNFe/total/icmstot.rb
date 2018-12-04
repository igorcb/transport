# encoding: UTF-8
module NFe
	class IcmsTot < NFe::EntidadeNFe
    attr_accessor :vBC
    attr_accessor :vICMS
    attr_accessor :vICMSDeson
    attr_accessor :vFCPUFDest
    attr_accessor :vICMSUFDest
    attr_accessor :vICMSUFRemet
    attr_accessor :vBCST
    attr_accessor :vST
    attr_accessor :vProd
    attr_accessor :vFrete
    attr_accessor :vSeg
    attr_accessor :vDesc
    attr_accessor :vII
    attr_accessor :vIPI
    attr_accessor :vPIS
    attr_accessor :vCOFINS
    attr_accessor :vOutro
    attr_accessor :vNF
    attr_accessor :vTotTrib

    def initialize(attrs = {})
	    self.vBC = attrs[:vBC]
	    self.vICMS = attrs[:vICMS]
	    self.vICMSDeson = attrs[:vICMSDeson]
	    self.vFCPUFDest = attrs[:vFCPUFDest] 
	    self.vICMSUFDest = attrs[:vICMSUFDest]
	    self.vICMSUFRemet = attrs[:vICMSUFRemet]
	    self.vBCST = attrs[:vBCST]
	    self.vST = attrs[:vST]
	    self.vProd = attrs[:vProd]
	    self.vFrete = attrs[:vFrete]
	    self.vSeg = attrs[:vSeg]
	    self.vDesc = attrs[:vDesc]
	    self.vII = attrs[:vII]
	    self.vIPI = attrs[:vIPI]
	    self.vPIS = attrs[:vPIS]
	    self.vCOFINS = attrs[:vCOFINS]
	    self.vOutro = attrs[:vOutro]
	    self.vNF = attrs[:vNF]
	    self.vTotTrib = attrs[:vTotTrib]
    end

    def attributes
      @attributes = {
			    "vBC" => vBC,
			    "vICMS" => vICMS,
			    "vICMSDeson" => vICMSDeson,
			    "vFCPUFDest" => vFCPUFDest, 
			    "vICMSUFDest" => vICMSUFDest,
			    "vICMSUFRemet" => vICMSUFRemet,
			    "vBCST" => vBCST,
			    "vST" => vST,
			    "vProd" => vProd,
			    "vFrete" => vFrete,
			    "vSeg" => vSeg,
			    "vDesc" => vDesc,
			    "vII" => vII,
			    "vIPI" => vIPI,
			    "vPIS" => vPIS,
			    "vCOFINS" => vCOFINS,
			    "vOutro" => vOutro,
			    "vNF" => vNF,
			    "vTotTrib" => vTotTrib
        }
    end

    def attributes=(params)
	    self.vBC = params['vBC'],
	    self.vICMS = params['vICMS'],
	    self.vICMSDeson = params['vICMSDeson'],
	    self.vFCPUFDest = params['vFCPUFDest'],
	    self.vICMSUFDest = params['vICMSUFDest'],
	    self.vICMSUFRemet = params['vICMSUFRemet'],
	    self.vBCST = params['vBCST'],
	    self.vST = params['vST'],
	    self.vProd = params['vProd'],
	    self.vFrete = params['vFrete'],
	    self.vSeg = params['vSeg'],
	    self.vDesc = params['vDesc'],
	    self.vII = params['vII'],
	    self.vIPI = params['vIPI'],
	    self.vPIS = params['vPIS'],
	    self.vCOFINS = params['vCOFINS'],
	    self.vOutro = params['vOutro'],
	    self.vNF = params['vNF'],
	    self.vTotTrib = params['vTotTrib']
    end
    
    # def xml_to_hash(xml) #node XML
    #   xml.children.css('enderDest').each do |p| 
		  #   self.vBC = p.css('vBC').text
		  #   self.vICMS = p.css('vICMS').text
		  #   self.vICMSDeson = p.css('vICMSDeson').text
		  #   self.vFCPUFDest = p.css('vFCPUFDest').text 
		  #   self.vICMSUFDest = p.css('vICMSUFDest').text
		  #   self.vICMSUFRemet = p.css('vICMSUFRemet').text
		  #   self.vBCST = p.css('vBCST').text
		  #   self.vST = p.css('vST').text
		  #   self.vProd = p.css('vProd').text
		  #   self.vFrete = p.css('vFrete').text
		  #   self.vSeg = p.css('vSeg').text
		  #   self.vDesc = p.css('vDesc').text
		  #   self.vII = p.css('vII').text
		  #   self.vIPI = p.css('vIPI').text
		  #   self.vPIS = p.css('vPIS').text
		  #   self.vCOFINS = p.css('vCOFINS').text
		  #   self.vOutro = p.css('vOutro').text
		  #   self.vNF = p.css('vNF').text
		  #   self.vTotTrib = p.css('vTotTrib').text

    #   end
    #   self
    # end    
  end
end
