require 'nfe'
class NfeXml < ActiveRecord::Base
	has_attached_file :asset
	validates_attachment :asset, uniqueness: true, attachment_presence: true, :content_type => { :content_type => "text/xml" }
	validates :asset_file_name, uniqueness: true

	before_create do |cte|
		cte.status = 0
		cte.error = 0
	end 

	module TipoStatus
		NAO_PROCESSADO = 0
		EM_PROCESSAMENTO = 1
		PROCESSADO = 2
	end

	module TipoError
		SEM_ERROR = 0
		COM_ERROR = 1
	end

	def status_name
		case self.status
		  when 0 then "Não Processado"
		  when 1 then "Em processamento"
		  when 2 then "Processado"
		end
  end

  def error_name
		case self.error
		  when 0 then "Sem Erros"
		  when 1 then "Contem Erros"
		end
  end

  def self.create_ordem_service(params)
    ActiveRecord::Base.transaction do
      nfe_xml = NfeXml.create(asset: params[:asset])
    	file = "#{Rails.root.join('public')}" + nfe_xml.asset.url(:original, timestamp: false)
    	nfe = NFe::NotaFiscal.new.load_xml_serealize(file)
    	#antes de gerar a ordem de servico verificar se todas as notas está para o mesmo CNPJ emitente
    	cnpj_source = nfe.emit.CNPJ.to_s
    	cnpj_source.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')
      cnpj_target = nfe.dest.CNPJ.to_s
      cnpj_target.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')
      chave_nfe = nfe_xml.asset_file_name.gsub(".xml", '')
    
    	source_client = Client.create_with(    
    																	tipo_pessoa: 1, 
    															group_client_id: 7, 
    																	  		 nome: nfe.emit.xNome, 
    																		 fantasia: nfe.emit.xNome, 
    																		 	    cep: nfe.emit.endereco_emitente.CEP, 
    																		 endereco: nfe.emit.endereco_emitente.xLgr, 
    																		   numero: nfe.emit.endereco_emitente.nro, 
    																	complemento: nfe.emit.endereco_emitente.xCpl, 
    																		   bairro: nfe.emit.endereco_emitente.xBairro, 
    																		   cidade: nfe.emit.endereco_emitente.xMun, 
    																		   estado: nfe.emit.endereco_emitente.UF).find_or_create_by(cpf_cnpj: cnpj_source)
    	target_client = Client.create_with(
    																	tipo_pessoa: 1, 
    															group_client_id: 7, 
    																	  		 nome: nfe.dest.xNome, 
    																		 fantasia: nfe.dest.xNome, 
    																		 	    cep: nfe.dest.endereco_destinatario.CEP, 
    																		 endereco: nfe.dest.endereco_destinatario.xLgr, 
    																		   numero: nfe.dest.endereco_destinatario.nro, 
    																	complemento: nfe.dest.endereco_destinatario.xCpl, 
    																		   bairro: nfe.dest.endereco_destinatario.xBairro, 
    																		   cidade: nfe.dest.endereco_destinatario.xMun, 
    																		   estado: nfe.dest.endereco_destinatario.UF).find_or_create_by(cpf_cnpj: cnpj_target)
    	billing_client = Client.find_by(cpf_cnpj: source_client.cpf_cnpj)
      ordem_service = OrdemService.create!( tipo: OrdemService::TipoOS::LOGISTICA,
      													target_client_id: target_client.id, 
           											source_client_id: source_client.id,
                               billing_client_id: billing_client.id,
      															  carrier_id: 11, #A MOURA DO NASCIMENTO - ME  # 3 - Nao Identificado
  																				estado: target_client.estado,
  																				cidade: target_client.cidade
      															             )
      # motorista não identificado 105
      ordem_service.ordem_service_logistics.create!(driver_id: 105, placa: nfe.veiculo.placa)
      ordem_service.nfe_keys.create!(nfe: nfe.ide.nNF, chave: chave_nfe, qtde: 0, volume: nfe.vol.qVol, peso: nfe.vol.pesoB)
    end
  end

end
