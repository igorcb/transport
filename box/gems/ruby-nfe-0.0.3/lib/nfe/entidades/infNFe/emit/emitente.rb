# encoding: UTF-8
module NFe
  class Emitente < NFe::EntidadeNFe
    attr_accessor :CNPJ
    attr_accessor :xNome
    attr_accessor :enderEmit
    attr_accessor :IE
    attr_accessor :IM
    attr_accessor :CNAE
    attr_accessor :CRT
    attr_accessor :endereco_emitente

    def initializer
      self.endereco_emitente = NFe::EnderecoEmitente.new
    end

    def attributes
      @attributes = {
          "CNPJ" => CNPJ,
          "xNome" => xNome,
          "enderEmit" => enderEmit,
          "IE" => IE,
          "IM" => IM,
          "CNAE" => CNAE,
          "CRT" => CRT,
        }
      #@endereco_emitente = @endereco_emitente.serealize(enderEmit)
    end

    def attributes=(params)
      @attributes = {
          "CNPJ" => params["CNPJ"],
          "xNome" => params["xNome"],
          "enderEmit" => params["enderEmit"],
          "IE" => params["IE"],
          "IM" => params["IM"],
          "CNAE" => params["CNAE"],
          "CRT" => params["CRT"]
        }
    end
  end
end