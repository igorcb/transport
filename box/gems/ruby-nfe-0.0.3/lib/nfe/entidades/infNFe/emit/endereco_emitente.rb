# encoding: UTF-8
module NFe
	class EnderecoEmitente < NFe::EntidadeNFe
    xml_name :enderEmit
	  attr_accessor :xLgr
    attr_accessor :nro
    attr_accessor :xCpl
    attr_accessor :xBairro
    attr_accessor :cMun
    attr_accessor :xMun
    attr_accessor :UF
    attr_accessor :CEP
    attr_accessor :cPais
    attr_accessor :xPais
    attr_accessor :fone

    def initialize(attrs = {})
      self.xLgr  = attrs[:xLgr]
      self.nro   = attrs[:nro]
      self.xCpl  = attrs[:xCpl]
      self.xBairro = attrs[:xBairro]
      self.cMun = attrs[:cMun]
      self.xMun = attrs[:xMun]
      self.UF   = attrs[:UF]
      self.CEP   = attrs[:CEP]
      self.cPais = attrs[:cPais]
      self.xPais = attrs[:xPais]
      self.fone  = attrs[:fone]
    end

    def attributes
      @attributes = {
          "xLgr" => xLgr,
          "nro" => nro,
          "xCpl" => xCpl,
          "xBairro" => xBairro,
          "cMun" => cMun,
          "xMun" => xMun,
          "UF" => UF,
          "CEP" => CEP,
          "cPais" => cPais,
          "xPais" => xPais,
          "fone" => fone
        }
    end

    def attributes=(params)
      self.xLgr  = params[:xLgr],
      self.nro   = params[:nro],
      self.xCpl  = params[:xCpl],
      self.xBairro = params[:xBairro],
      self.cMun = params[:cMun],
      self.xMun = params[:xMun],
      self.UF   = params[:UF],
      self.CEP   = params[:CEP],
      self.cPais = params[:cPais],
      self.xPais = params[:xPais],
      self.fone  = params[:fone]
    end
    
    def xml_to_hash(xml) #node XML
      xml.children.css('enderEmit').each do |p| 
        self.xLgr = p.css('xLgr').text
        self.nro  = p.css('nro').text
        self.xCpl = p.css('xCpl').text
        self.xBairro = p.css('xBairro').text
        self.cMun = p.css('cMun').text
        self.xMun = p.css('xMun').text
        self.UF   = p.css('UF').text
        self.CEP   = p.css('CEP').text
        self.cPais = p.css('cPais').text
        self.xPais = p.css('xPais').text
        self.fone  = p.css('fone').text
      end
      self
    end    
  end
end
