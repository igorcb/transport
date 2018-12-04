# encoding: UTF-8
module NFe
  class Destinatario < NFe::EntidadeNFe
    xml_name :emit
    attr_accessor :xNome
    attr_accessor :CNPJ
    attr_accessor :enderDest
    attr_accessor :indIEDest
    attr_accessor :IE
    attr_accessor :endereco_destinatario

    def initializer
      self.endereco_destinatario = NFe::EnderecoDestinatario.new
    end

    def attributes
      @attributes = {
          "xNome" => xNome,
          "CNPJ" => CNPJ,
          "enderEmit" => @enderEmit,
          "indIEDest" => indIEDest,
          "IE" => IE
        }
    end

    def attributes=(params)
      @attributes = {
          "xNome" => params["razao_social"],
          "CNPJ" => params["cnpj"],
          "enderDest" => params["enderDest"],
          "indIEDest" => params["indIEDest"],
          "IE" => params["IE"],
        }
    end
  end
end