# encoding: UTF-8
#module NFe
class Produto
  attr_accessor :cProd
  attr_accessor :cEAN
  attr_accessor :xProd
  attr_accessor :NCM
  attr_accessor :EXTIPI
  attr_accessor :CFOP
  attr_accessor :uCom
  attr_accessor :qCom
  attr_accessor :vUnCom
  attr_accessor :vProd
  attr_accessor :cEANTrib
  attr_accessor :uTrib
  attr_accessor :qTrib
  attr_accessor :vUnTrib
  attr_accessor :indTot
  attr_accessor :xPed
  attr_accessor :xPed
  attr_accessor :all_products

  def initialize(attrs = {})
    self.cProd  = attrs[:cProd]
    self.cEAN   = attrs[:cEAN]
    self.xProd  = attrs[:xProd]
    self.NCM    = attrs[:NCM]
    self.EXTIPI = attrs[:EXTIPI]
    self.CFOP   = attrs[:CFOP]
    self.uCom   = attrs[:uCom]
    self.qCom   = attrs[:qCom]
    self.vUnCom = attrs[:vUnCom]
    self.vProd  = attrs[:vProd]
    self.cEANTrib = attrs[:cEANTrib]
    self.uTrib  = attrs[:uTrib]
    self.qTrib  = attrs[:qTrib]
    self.vUnTrib = attrs[:vUnTrib]
    self.indTot  = attrs[:indTot]
    self.xPed    = attrs[:xPed]
    self.all_products = []
  end

  def attributes
    { "cProd" => cProd,
      "cEAN" => cEAN,
      "xProd" => xProd,
      "NCM" => NCM,
      "EXTIPI" => EXTIPI,
      "CFOP" => CFOP,
      "uCom" => uCom,
      "qCom" => qCom,
      "vUnCom" => vUnCom,
      "vProd" => vProd,
      "cEANTrib" => cEANTrib,
      "uTrib" => uTrib,
      "qTrib" => qTrib,
      "vUnTrib" => vUnTrib,
      "indTot" => indTot,
      "xPed" => xPed
    }
  end

  def attributes=(params)
    self.cProd  = params["cProd"]
    self.cEAN   = params["cEAN"]
    self.xProd  = params["xProd"]
    self.NCM    = params["NCM"]
    self.EXTIPI = params["EXTIPI"]
    self.CFOP   = params["CFOP"]
    self.uCom   = params["uCom"]
    self.qCom   = params["qCom"]
    self.vUnCom = params["vUnCom"]
    self.vProd  = params["vProd"]
    self.cEANTrib = params["cEANTrib"]
    self.uTrib  = params["uTrib"]
    self.qTrib  = params["qTrib"]
    self.vUnTrib = params["vUnTrib"]
    self.indTot = params["indTot"]
    self.xPed   = params["xPed"]
  end

  def xml_to_hash(xml) #file xml
    doc = Nokogiri::XML(File.open(xml))
    prods = doc.elements.css('prod').map do |p| 
      {
        'cProd' => p.css('cProd').text,
        'cEAN' => p.css('cEAN').text,
        'xProd' => p.css('xProd').text,
        'NCM' => p.css('NCM').text,
        'EXTIPI' => p.css('EXTIPI').text,
        'CFOP' => p.css('CFOP').text,
        'uCom' => p.css('uCom').text,
        'qCom' => p.css('qCom').text,
        'vUnCom' => p.css('vUnCom').text,
        'vProd' => p.css('vProd').text,
        'cEANTrib' => p.css('cEANTrib').text,
        'uTrib' => p.css('uTrib').text,
        'qTrib' => p.css('qTrib').text,
        'vUnTrib' => p.css('vUnTrib').text,
        'indTot' => p.css('indTot').text,
        'xPed' => p.css('xPed').text
      }
    end
    prods.each {|p| self.all_products.push(p) }
  end
end