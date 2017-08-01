require 'nfe'
class NfeXml < ActiveRecord::Base
	has_attached_file :asset
	validates_attachment :asset, uniqueness: true, attachment_presence: true, :content_type => { :content_type => "text/xml" }
	validates :asset_file_name, uniqueness: { scope: :nfe_type } 
  validates :chave, uniqueness: { scope: :nfe_type } 

  belongs_to :input_control, class_name: "InputControl", foreign_key: "nfe_id"
  belongs_to :source_client, class_name: "Client", foreign_key: "source_client_id"
  belongs_to :target_client, class_name: "Client", foreign_key: "target_client_id"

  has_many :item_input_controls
  
  scope :not_create_os, -> { where(create_os: TipoOsCriada::NAO) }
  scope :nfe, -> { joins(:target_client).where(equipamento: TipoEquipamento::NOTA_FISCAL).order("clients.cpf_cnpj") }
  scope :pallets, -> { where(equipamento: TipoEquipamento::PALETE) }

	before_create do |cte|
		cte.status = 0
		cte.error = 0
    cte.create_os = 0
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

  module TipoEquipamento
    NOTA_FISCAL = 0
    PALETE = 1
    CINTA = 2
    CHAPATEX = 3
  end

  module TipoOsCriada
    NAO = 0
    SIM = 1
  end

  module TypeOrdemService
    DIRECT_CHARGES = "DirectCharge"
    INPUT_CONTROL  = "InputControl"
  end

  def status_os_create
    case self.create_os
      when 0 then "Nao"
      when 1 then "Sim"
      else "Nao Informado"
    end
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

  def equipamento_name
    case self.equipamento
      when 0 then "Nota Fiscal"
      when 1 then "Palete"
      when 1 then "Cinta"
      when 1 then "Chapatex"
      else "Nao Informado"
    end
  end

  # def ordem_service=(number)
  #   # Procurar todas as notas de numero X
  #   #
  #   nfe_key = NfeKey.where(nfe_type: 'OrdemService', nfe: self.numero)
  #   os = nfe_key.present? ? nfe_key.first.ordem_service : nil
  #   type_os = os.direct_charge_id.present? ? TypeOrdemService::DIRECT_CHARGES : TypeOrdemService::INPUT_CONTROL
  #   ordem_service(type_os, number)
  # end

  def ordem_service(type_os)
    case type_os
      when 'direct_charges' then nfe_key = NfeKey.where(nfe_source_type: 'DirectCharge', nfe_type: 'OrdemService', nfe: self.numero)
      when 'input_controls' then nfe_key = NfeKey.where(nfe_source_type: 'InputControl', nfe_type: 'OrdemService', nfe: self.numero)
    end
    ordem_service = nfe_key.present? ? nfe_key.first.ordem_service : nil
  end

  # def ordem_services_status
  #   ordem_service.status_name
  # end

  def self.processa_xml_input_control(params)
    if params.status == TipoStatus::NAO_PROCESSADO
      ActiveRecord::Base.transaction do
        #processar xml - extrair os daddos da nfe 
        # - atualizar campos na tabela nfe_xml
        # - criar produtos na tabela item_input_control
        nfe_xml = params
        file = "#{Rails.root.join('public')}" + nfe_xml.asset.url(:original, timestamp: false)
        puts ">>>>>>>>>>>>>>>>>>>> Processando File #{file}"
        nfe = NFe::NotaFiscal.new.load_xml_serealize(file)
        #antes de gerar a ordem de servico verificar se todas as notas está para o mesmo CNPJ emitente
        cnpj_source = nfe.emit.CNPJ.to_s
        cnpj_source.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')
        cnpj_target = nfe.dest.CNPJ.to_s
        cnpj_target.insert(2, '.').insert(6, '.').insert(10, '/').insert(15, '-')

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
        peso = nfe.vol.pesoB.nil? ? nfe.vol.pesoL : nfe.vol.pesoB
        nfe_xml.update_attributes(peso: peso, 
                          peso_liquido: nfe.vol.pesoL,
                                volume: nfe.vol.qVol, 
                                numero: nfe.ide.nNF,
                                 chave: nfe.infoProt.chNFe,
                            valor_nota: nfe.icms_tot.vNF,
                      source_client_id: source_client.id,
                      target_client_id: target_client.id,
                                status: TipoStatus::PROCESSADO)

        #produtos da NFE
        #input_control = InputControl.find(nfe_xml.nfe_id)
        nfe.prod.each do |product|
          prod = Produto.new
          prod.attributes=(product)
          produto = Product.create_with(category_id: 6, 
                                        cubagem: 0,
                                    cod_prod: prod.cProd, 
                                   descricao: prod.xProd, 
                                         ean: prod.cEAN,
                                    ean_trib: prod.cEANTrib,
                                         ncm: prod.NCM,
                                        cfop: prod.CFOP,
                                 unid_medida: prod.uCom,
                              valor_unitario: prod.vUnTrib).find_or_create_by(cod_prod: prod.cProd)

          nfe_xml.item_input_controls.create!(
                                        input_control_id: nfe_xml.nfe_id,
                                              number_nfe: nfe.ide.nNF,
                                              product_id: produto.id,
                                                    qtde: prod.qCom,
                                               qtde_trib: prod.qTrib,
                                                   valor: prod.vProd,
                                          valor_unitario: prod.vUnTrib,
                                    valor_unitario_comer: prod.vUnCom,
                                             unid_medida: prod.uCom
                                      )


        end

      end
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
      placa = nfe.veiculo.placa.present? ? nfe.veiculo.placa.insert(3, '-') : 'ZZZ-9999'
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
                                            peso: nfe.vol.pesoB, 
                                     qtde_volume: nfe.vol.qVol,
  																				estado: target_client.estado,
  																				cidade: target_client.cidade,
                                      observacao: nfe.info.infCpl
      															             )
      # motorista não identificado 105
      ordem_service.ordem_service_logistics.create!(driver_id: 105, placa: placa, peso: nfe.vol.pesoB, qtde_volume: nfe.vol.qVol)
      ordem_service.nfe_keys.create!(nfe: nfe.ide.nNF, chave: nfe.infoProt.chNFe, qtde: 0, volume: nfe.vol.qVol, peso: nfe.vol.pesoB)
      nfe.prod.each do |product|
        prod = Produto.new
        prod.attributes=(product)
                                  #produtos da NFE
        produto = Product.create_with(category_id: 6, 
                                      cubagem: 0,
                                  cod_prod: prod.cProd, 
                                 descricao: prod.xProd, 
                                       ean: prod.cEAN,
                                  ean_trib: prod.cEANTrib,
                                       ncm: prod.NCM,
                                      cfop: prod.CFOP,
                               unid_medida: prod.uCom,
                            valor_unitario: prod.vUnTrib).find_or_create_by(cod_prod: prod.cProd)
        
        ordem_service.item_ordem_services.create!(number: nfe.ide.nNF,
                                              product_id: produto.id,
                                                    qtde: prod.qCom,
                                               qtde_trib: prod.qTrib,
                                                   valor: prod.vProd,
                                          valor_unitario: prod.vUnTrib,
                                    valor_unitario_comer: prod.vUnCom,
                                             unid_medida: prod.uCom
                                      )
      end
      
    end
  end

end
