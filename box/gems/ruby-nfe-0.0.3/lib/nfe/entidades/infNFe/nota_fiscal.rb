# encoding: UTF-8
module NFe
	class NotaFiscal < NFe::EntidadeNFe
		xml_name :infNFe
    
    attr_accessor :ide
    attr_accessor :emit
    attr_accessor :dest
    attr_accessor :prod
    attr_accessor :icms_tot
    attr_accessor :transp
    attr_accessor :veiculo
    attr_accessor :vol
    attr_accessor :info
    attr_accessor :infoProt

		def initializer
			#@versao_processo_emissao = Nfe::Config::Params::VERSAO_PADRAO
			@ide = NFe::IdentificacaoNFe.new
			@emit = NFe::Emitente.new
			@emit.endereco_emitente = NFe::EnderecoEmitente.new
			@dest = NFe::Destinatario.new
			@dest.endereco_destinatario = NFe::EnderecoDesinatario.new
			@prod = []
			@icms_tot = NFe::IcmsTot.new
			@transp = NFe::Transportadora.new
			@veiculo = NFe::Veiculo.new
			@vol = NFe::Volume.new
			@info = NFe::Info.new
			@infoProt = NFe::InfoProtocolo.new
			@versao = '2.0' #criar uma constante em params da versao da NF-e
		end

		def load_xml_serealize(file)
			doc = Nokogiri::XML(File.open(file))
			self.ide = NFe::IdentificacaoNFe.new
			self.emit = NFe::Emitente.new
			self.dest = NFe::Destinatario.new
			self.emit.endereco_emitente = NFe::EnderecoEmitente.new
			self.icms_tot = NFe::IcmsTot.new
			self.transp = NFe::Transportadora.new
			self.veiculo = NFe::Veiculo.new
			self.vol = NFe::Volume.new
			self.info = NFe::Info.new
			self.infoProt = NFe::InfoProtocolo.new
			produto = Produto.new
			produto.xml_to_hash(file)
			
			self.ide.serialize(@ide.xml_to_hash(doc.elements.css('ide')))
			self.emit.serialize(@emit.xml_to_hash(doc.elements.css('emit')))
			self.emit.endereco_emitente = NFe::EnderecoEmitente.new.xml_to_hash(doc.elements.css('emit'))
			self.dest.serialize(@dest.xml_to_hash(doc.elements.css('dest')))
			self.dest.endereco_destinatario = NFe::EnderecoDestinatario.new.xml_to_hash(doc.elements.css('dest'))
			self.icms_tot.serialize(@icms_tot.xml_to_hash(doc.elements.css('total/ICMSTot')))
			self.transp.serialize(@transp.xml_to_hash(doc.elements.css('transp/transporta')))
			self.veiculo.serialize(@veiculo.xml_to_hash(doc.elements.css('transp/veicTransp')))
			self.vol.serialize(@vol.xml_to_hash(doc.elements.css('transp/vol')))
			self.info.serialize(@info.xml_to_hash(doc.elements.css('infAdic')))
			self.infoProt.serialize(@infoProt.xml_to_hash(doc.elements.css('protNFe/infProt')))
			self.prod = produto.all_products
			self

		end
	end

end