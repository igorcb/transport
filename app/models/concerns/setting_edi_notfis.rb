module SettingEdiNotfis
  extend ActiveSupport::Concern
  included do
	  # Struct.new("Carrier", :idregistro)
	  NotfisHeader = Struct.new("NotfisHeader", :idregistro, :idremetente, :iddestinatario, :data, :hora, :intercambio, :filler)
	  HeaderDocument = Struct.new("HeaderDocument", :idregistro, :iddocumento, :filler)
	  Shipper = Struct.new("Shipper", :idregistro, :cnpj, :ie, :endereco, :cidade, :cep, :subentidade, :dataembarque, :empresa, :filler)
	  TargetClient = Struct.new("TargetClient", :idregistro, :cnpj, :ie, :endereco, :cidade, :cep, :codmunicipio, :subentidade, :area, :comunicacao, :iddestinatario, :filler)
	  DataNFe = Struct.new("DataNFe", :idregistro, :numromaneio, :codigorota, :meiotransporte, :tipotransporte, :tipocarga, :condicaofrete, :serie, :numeronota, :dataemissao, :natureza, :acondicionamento, :acondicionamentos, :qtdevolumes, :valortotalnota, :pesototal, :pesocubagem, :tpicms, :seguro, :valorseguro, :valorcobrado, :placa, :planocarga,:fretepeso, :fretevalor, :valoroutrastaxas, :valortotalfrete, :acaodocumento, :valoricms, :valoricmsretido, :indicacaobonificacao, :xquantidade, :relacao)
	  DataComplementary = Struct.new("DataComplementary", :idregistro, :codigooperfiscal, :tipoperiodoentrega,:datainicialentrega, :horainicialentrega, :datafinalentrega, :horafinalentrega, :idlocaldesembarque, :calculofretediferenciado, :idtabelafrete, :cgcentregue1, :seriec1, :numeroc1, :cgcentregue2, :seriec2, :numeroc2, :cgcentregue3, :seriec3, :numeroc3, :cgcentregue4, :seriec4, :numeroc4, :cgcentregue5, :seriec5, :numeroc5, :filler1, :tipoveiculo, :filler2)
	  NfeItem = Struct.new("NfeItem", :idregistro, :quantvol1, :espacond1, :mercadoria1, :quantvol2, :espacond2, :mercadoria2, :quantvol3, :espacond3, :mercadoria3, :quantvol4, :espacond4, :mercadoria4, :filler)
	  Carrier = Struct.new("Carrier", :razaosocial, :cnpj, :ie, :endereco, :bairro, :cidade, :cep, :codmunicipio, :subentidade, :comunicacao, :filler)
	  ResponsibleFreight = Struct.new("Carrier", :idregistro, :razaosocial, :cgccpf, :ie, :endereco, :bairro, :cidade, :cep, :codmunicipio, :subentidade, :comunicacao, :filler)
	  ShippingCompany = Struct.new("ShippingCompany", :idregistro, :razaosocial,:cgccpf, :inscricaoestadual, :endereco, :bairro, :cidade, :cep, :codmunicipio, :subentidade, :areafrete, :comunicacao, :filler)
	  Trailler = Struct.new("Trailler", :idregistro, :valortotalnotas,:pesototalnotas,:cubagemtotalnotas,:quantidadetotalvolumes,:valortotalcobrado,:valortotalseguro,:filler)
  	  	
  	def read_header(line, params)
			hash = {idregistro: line[0,3],
							idremetente: line[3,35],
							iddestinatario:line[38,35],
							data: line[73,6],
							hora: line[79,4],
							intercambio: line[83,12],
							filler: line[95,145]}
			puts "ReadHeader: #{hash}"
			puts "ReadHeaderSerialize: #{serialize(hash)}"
			#NotfisHeader.new(serialize(hash))
  	end

  	def read_header_document(line, params)
			hash = {idregistro: line[0,3],
							iddocumento: line[3,14],
							filler: line[14,223]}

			params = serialize(hash)
  	end

  	def read_embarcadora(line, params)
			hash = {
				idregistro: line[0,3],
				cnpj: line[3,14],
				ie: line[17,15],
				endereco: line[32,15],
				cidade: line[72,35],
				cep: line[107,9],
				subentidade: line[116,9],
				dataembarque: line[125,8],
				empresa: line[133,40],
				filler: line[173,240]
			}
			params = serialize(hash)
  	end

  	def read_target_client(line, params)
			hash = {
				idregistro: line[0,3],
				razaosocial: line[3,40],
				cnpj: line[43,14],
				ie: line[57,15],
				endereco: line[72,40],
				cidade: line[132,35],
				cep: line[167,9],
				codmunicipio: line[176,9],
				subentidade: line[185,9],
				area: line[194,9],
				comunicacao: line[198,9],
				iddestinatario: line[233,9],
				filler: line[234,240]
			}
			params = serialize(hash)
  	end

  	def read_data_nfe(line, params)
  		hash = {
				idregistro: line[0,3],
				numromaneio: line[3,15],
				codigorota: line[18,7],
				meiotransporte: line[25,1],
				tipotransporte: line[26,1],
				tipocarga: line[27,1],
				condicaofrete: line[28,1],
				serie: line[29,3],
				numeronota: line[32,9],
				dataemissao: line[41,8],
				natureza: line[49,15],
				acondicionamento: line[64,0],
			  acondicionamentos: line[64,15],
				qtdevolumes: line[79,7],
				valortotalnota: line[86,15],
				pesototal: line[101,7],
				pesocubagem: line[108,5],
				tpicms: line[113,1],
				seguro: line[114,1],
				valorseguro: line[115,15],
				valorcobrado: line[130,15],
				placa: line[145,7],
				planocarga: line[152,1],
				fretepeso: line[153,15],
				fretevalor: line[168,15],
				valoroutrastaxas: line[183,15],
				valortotalfrete: line[198,15],
				acaodocumento: line[213,1],
				valoricms: line[214,12],
				valoricmsretido: line[226,12],
				indicacaobonificacao: line[238,1],
				xquantidade: line[239,3],
				relacao: line[242,10]
  		}
			params = serialize(hash)
  	end

  	def read_data_complementary(line, params)
  		hash = {
  			idregistro: line[0,3],
				codigooperfiscal: line[3,4],
				tipoperiodoentrega: line[7,1],
				datainicialentrega: line[8,8],
				horainicialentrega: line[16,4],
				datafinalentrega: line[20,8],
				horafinalentrega: line[28,0],
				idlocaldesembarque: line[32,15],
				calculofretediferenciado: line[47,1],
				idtabelafrete: line[48,10],
				cgcentregue1: line[58,15],
				seriec1: line[73,3],
				numeroc1: line[76,8],
				cgcentregue2: line[84,15],
				seriec2: line[99,3],
				numeroc2: line[102,8],
				cgcentregue3: line[110,15],
				seriec3: line[125,3],
				numeroc3: line[128,8],
				cgcentregue4: line[136,15],
				seriec4: line[151,3],
				numeroc4: line[154,8],
				cgcentregue5: line[162,15],
				seriec5: line[117,3],
				numeroc5: line[180,8],
				filler1: line[188,15],
				tipoveiculo: line[203,5],
				filler2: line[208,32]
  		}
  		params = serialize(hash)
  	end

  	def read_nfe_item(line, params)
			hash = {idregistro: line[0,3],
				quantvol1: line[3,7],
				espacond1: line[10,15],
				mercadoria1: line[25,30],
				quantvol2: line[55,7],
				espacond2: line[62,15],
				mercadoria2: line[77,30],
				quantvol3: line[107,7],
				espacond3: line[114,15],
				mercadoria3: line[129,30],
				quantvol4: line[159,7],
				espacond4: line[166,15],
				mercadoria4: line[181,30],
				filler: line[211,29]
			}
			params = serialize(hash)
  	end

  	def read_carrier(line, params)
			hash = {
				idregistro: line[0,3],
				razaosocial: line[3,40],
				cnpj: line[43,14],
				ie: line[57,15],
				endereco: line[72,40],
				cidade: line[132,35],
				cep: line[167,9],
				codmunicipio: line[176,9],
				subentidade: line[185,9],
				comunicacao: line[194,35],
				filler: line[229,11]
			}
			params = serialize(hash)
  	end

  	def read_shipping_company(line, params)
			hash = {
				idregistro: line[0,3],
				razaosocial: line[3,40],
				cnpj: line[43,14],
				ie: line[57,15],
				endereco: line[72,40],
				cidade: line[132,35],
				cep: line[167,9],
				codmunicipio: line[176,9],
				subentidade: line[185,9],
				areafrete: line[194,4],
				comunicacao: line[198,35],
				filler: line[223,7]
			}
			params = serialize(hash)
  	end

  	def read_responsible_freight(line, params)
			hash = {
				idregistro: line[0,3],
				razaosocial: line[3,40],
				cnpj: line[43,14],
				ie: line[57,15],
				endereco: line[72,40],
				cidade: line[132,35],
				cep: line[167,9],
				codmunicipio: line[176,9],
				subentidade: line[185,9],
				numeropedido: line[194,12],
				comunicacao: line[206,23],
				filler: line[229,7]
			}
			params = serialize(hash)
  	end

  	def read_trailler(line, params)
  		hash = {
  			idregistro: line[0,3],
				valortotalnotas: line[3,15],
				pesototalnotas: line[18,15],
				cubagemtotalnotas: line[33,15],
				quantidadetotalvolumes: line[48,15],
				valortotalcobrado: line[63,15],
				valortotalseguro: line[78,15],
				filler: line[93,147]
  		}
  		params = serialize(hash)
  	end

    def serialize(params)
      params.each do |key, value|
        #send("#{key}=", value) if respond_to?(key)
				send(key, value) if respond_to?(key)
      end    
    end

  end
end

