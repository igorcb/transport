require 'nfe'
class NfeXml < ActiveRecord::Base
	include ClientCreateOrUpdate
	include ProductCreateOrUpdate
	has_attached_file :asset, { validate_media_type: false }
	validates_attachment :asset, {
    content_type: { content_type: ["application/xml", "text/plain", Paperclip::ContentTypeDetector::SENSIBLE_DEFAULT] }
	}

	has_attached_file :action_inspector
  #validates :asset, presence: true
  validates :asset_file_name, uniqueness: { scope: :nfe_type }
  validates :chave, uniqueness: { scope: :nfe_type }, allow_blank: true
	validates :equipamento, presence: true

  belongs_to :scheduling, class_name: "Scheduling", foreign_key: "nfe_id", required: false
  belongs_to :input_control, class_name: "InputControl", foreign_key: "nfe_id", required: false
  belongs_to :direct_charge, class_name: "DirectCharge", foreign_key: "nfe_id", required: false
  belongs_to :notfis, class_name: "NotFis", foreign_key: "nfe_id", required: false
  belongs_to :source_client, class_name: "Client", foreign_key: "source_client_id", required: false
  belongs_to :target_client, class_name: "Client", foreign_key: "target_client_id", required: false

  has_many :item_input_controls

  scope :not_create_os, -> { where(create_os: TipoOsCriada::NAO) }
	scope :is_not_input, -> { where(nfe_type: nil ) }
  scope :nfe, -> { joins(:target_client).where(equipamento: TipoEquipamento::NOTA_FISCAL).order("clients.cpf_cnpj") }
  scope :pallets, -> { where(equipamento: TipoEquipamento::PALETE) }

	enum status: { nao_processado: 0, processando: 1, processado: 2 }

	before_create do |cte|
		cte.status = 0
		cte.error = 0
    cte.create_os = 0
	end

  module TypeNfe
    SCHEDULING   = "Scheduling"
    INPUTCONTROL = "InputControl"
    DIRECTCHARGE = "DirectCharge"
    NOTFIS = "Notfis"
  end

	module TipoStatus
		NAO_PROCESSADO = 0
		EM_PROCESSAMENTO = 1
		PROCESSADO = 2
    RECEBIDO = 3
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

  module TypeOrdemServiceController
    DIRECT_CHARGES = "direct_charges"
    INPUT_CONTROL  = "input_controls"
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

	def has_input_control
	  nfe_id.present? ? "Sim" : "Não"
	end

  def self.client_ids
    NfeXml.select(:target_client_id).pluck(:target_client_id).uniq
  end

  def ordem_service(type_os)
    case type_os.downcase
		when 'direct_charges' then nfe_key = NfeKey.where(nfe_source_type: 'DirectCharge', nfe_type: 'OrdemService', nfe: self.numero, chave: self.chave)
		when 'input_controls' then nfe_key = NfeKey.where(nfe_source_type: 'InputControl', nfe_type: 'OrdemService', nfe: self.numero, chave: self.chave)
    end
    ordem_service = nfe_key.present? ? nfe_key.first.ordem_service : nil
  end

  # def ordem_services_status
  #   ordem_service.status_name
  # end

	def xml_process(id)
		nfe_xml = NfeXml.find(id)
		NfeXmls::ProcessXmlService.new(nfe_xml).call
	end

  def self.processa_xml_input_control(params)
		NfeXmls::ProcessXmlInputControlService.new(params).call
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
                               #billing_client_id: billing_client.id,
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
