require File.dirname(__FILE__) + '/../../config/environment.rb'

class ReportsController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
	def index
	end

  def print_boarding
    @boarding = Boarding.find(params[:id])
    # For Rails 3 or latest replace #{RAILS_ROOT} to #{Rails.root}
    report = ODFReport::Report.new("#{Rails.root}/app/reports/embarque.odt") do |r|
      r.add_field(:NO_EMB, "L7/CE #{@boarding.id.to_s.rjust(3, "0")}")
      r.add_field(:MOTORISTA, @boarding.driver.nome)
      r.add_field(:MOTORISTA_CPF, @boarding.driver.cpf)
      r.add_field(:MOTORISTA_RG, @boarding.driver.rg)
      r.add_field(:MOTORISTA_CNH, @boarding.driver.cnh)
      r.add_field(:CNH_REG, @boarding.driver.registro_cnh)
      r.add_field(:CNH_VAL, date_br(@boarding.driver.validade_cnh))
      
      r.add_field(:AGENTE, @boarding.carrier.fantasia)
      r.add_field(:AGENTE_RAZAO_SOCIAL, @boarding.carrier.nome) #RAZAO SOCIAL
      r.add_field(:AGENTE_CNPJ, @boarding.carrier.cnpj) 
      r.add_field(:AGENTE_ENDERECO, @boarding.carrier.endereco) 
      r.add_field(:AGENTE_COMPLEMENTO, @boarding.carrier.complemento) 
      r.add_field(:AGENTE_BAIRRO, @boarding.carrier.bairro + ' - ' + @boarding.carrier.cidade) 

      #rodapé
      r.add_field(:DATA_EXPEDICAO, date_br(@boarding.date_boarding))      
      r.add_field(:PESO_BRUTO, "#{number_to_currency(@boarding.peso_bruto, precision: 3, unit: "", separator: ",", delimiter: ".")}")
      r.add_field(:VOLUME_TOTAL, "#{number_to_currency(@boarding.volume_total, precision: 3, unit: "", separator: ",", delimiter: ".")}")
      r.add_field(:CANHOTO_CTE, @boarding.qtde_cte)
      r.add_field(:CANHOTO_NFE, @boarding.qtde_nfe)
      r.add_field(:QTDE_PALETES, @boarding.qtde_palets)
      r.add_field(:QTDE_ENTREGAS, @boarding.qtde_entregas)

      r.add_table("TABELA_VEICULOS", @boarding.boarding_vehicles, :header=>true) do |t|

        t.add_column(:FIELD_03) { |item| "#{item.vehicle.tipo_nome}" }
        t.add_column(:FIELD_04) { |item| "#{item.vehicle.placa}" }
        t.add_column(:ADDRESS)  { |item| "#{item.vehicle.antt}" }
        
      end
      r.add_table("TABLE_02", @boarding.boarding_items, :header=>true) do |t|

        t.add_column(:FIELD_01) { |item| "#{item.delivery_number}" }
        t.add_column(:FIELD_02) { |item| "#{item.ordem_service.id}" }
        t.add_column(:ADDRESS)  { |item| "#{date_br(item.ordem_service.data)}" }
        t.add_column(:FIELD_03) { |item| "#{item.ordem_service.client.nome}" }
        t.add_column(:FIELD_04) { |item| "#{item.ordem_service.client.cidade}" }
        t.add_column(:FIELD_05) { |item| "#{item.ordem_service.client.estado}" }
        t.add_column(:FIELD_06) { |item| "#{item.ordem_service.get_number_nfe}" }
        t.add_column(:FIELD_07) { |item| "#{number_to_currency(item.ordem_service.peso, precision: 3, unit: "", separator: ",", delimiter: ".")}" }
        t.add_column(:FIELD_08) { |item| "#{number_to_currency(item.ordem_service.qtde_volume, precision: 3, unit: "", separator: ",", delimiter: ".")}" }
        
      end

    end
    name_report = "Embarque_#{@boarding.id}"
    send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
                                disposition: 'attachment',
                                filename: "#{name_report}.odt"
  end

  def print_billing
    @billing = Billing.find(params[:id])
    @client = @billing.ordem_services.first.source_client
    # For Rails 3 or latest replace #{RAILS_ROOT} to #{Rails.root}
    report = ODFReport::Report.new("#{Rails.root}/app/reports/fatura.odt") do |r|
      valor = (@billing.valor.to_f * 100).to_i
      puts ">>>>>>>>>>>>>> Valor: #{valor}"
      r.add_field(:no_fatura, @billing.id)
      r.add_field(:vr_fatura, @billing.valor)
      r.add_field(:OBS, @billing.observacao)
      r.add_field(:no_duplicata, "#{@billing.id} / #{extract_year(@billing.data)}")
      #r.add_field(:ano_duplicata, extract_year(@billing.data))
      #r.add_field(:vencimento, date_br(@billing.data + @client.vencimento_para.days))
      r.add_field(:vencimento, date_br(@billing.data_vencimento))
      r.add_field(:emitida_em, date_br(@billing.data))
      r.add_field(:vr_total, @billing.valor)
      r.add_field(:valor_por_extenso, Extenso.moeda(valor)) #multiplicar por 100 para gerar as casas decimais
      @client = @billing.ordem_services.first.billing_client
      r.add_field(:nome_sacado, @client.nome)
      r.add_field(:endereco_sacado, "#{@client.endereco}, #{@client.numero}")
      r.add_field(:bairro_sacado, @client.bairro)
      r.add_field(:cidade_sacado, @client.cidade)
      r.add_field(:uf, @client.estado)
      r.add_field(:cnpj_sacado, @client.cpf_cnpj)
      r.add_field(:ie_sacado, @client.inscricao_estadual)

      r.add_table("TABLE_01", @billing.ordem_services, :header=>true) do |t|
        t.add_column(:FIELD_04) { |os| "#{os.id}" }
        t.add_column(:FIELD_05) { |os| "#{date_br(os.data_entrega_servico)}" }
        t.add_column(:FIELD_06, :valor_ordem_service)
        t.add_column(:FIELD_07) { |os| "#{os.get_number_cte}" }
        t.add_column(:FIELD_08) { |os| "#{os.get_number_nfse}" }
        t.add_column(:FIELD_09) { |os| "#{os.get_number_nfe}" }
        t.add_column(:ADDRESS)  { |os| "#{os.get_type_service}" }
      end

    end
    name_report = "Fatura_#{@billing.id}"
    send_data report.generate, type: 'application/vnd.oasis.opendocument.text',
                                disposition: 'attachment',
                                filename: "#{name_report}.odt"
  end
  
  def print_contract
    @ordem_service = OrdemService.find(params[:id])
  	report = ODFReport::Report.new("#{Rails.root}/app/reports/contrato_mudanca.odt") do |r|
   		r.add_field :client_nome, @ordem_service.client.nome
      r.add_field :cpf_cnpj, @ordem_service.client.cpf_cnpj
      r.add_field :doc_rg, @ordem_service.client.rg
      r.add_field :tipo_mudanca, @ordem_service.ordem_service_change.status_compartilhado
      r.add_field :trecho, @ordem_service.ordem_service_change.stretch
      r.add_field :data_prevista, date_br(@ordem_service.data)
      r.add_field :dias, @ordem_service.ordem_service_change.dias
      r.add_field :data_limite, date_br(@ordem_service.ordem_service_change.date_limit)
      r.add_field :telefone_contatos, @ordem_service.client.fone_all
      r.add_field :endereco_origem, @ordem_service.ordem_service_change.source_endereco +
                                    @ordem_service.ordem_service_change.source_numero
      r.add_field :complemento_origem, @ordem_service.ordem_service_change.source_complemento
      r.add_field :bairro_origem, @ordem_service.ordem_service_change.source_bairro
      r.add_field :cidade_origem, @ordem_service.ordem_service_change.source_cidade
      r.add_field :estado_origem, @ordem_service.ordem_service_change.source_estado
      r.add_field :cep_origem, @ordem_service.ordem_service_change.source_cep
      r.add_field :endereco_destino, @ordem_service.ordem_service_change.target_endereco +
                                    @ordem_service.ordem_service_change.target_numero
      r.add_field :complemento_destino, @ordem_service.ordem_service_change.target_complemento
      r.add_field :bairro_destino, @ordem_service.ordem_service_change.target_bairro
      r.add_field :cidade_destino, @ordem_service.ordem_service_change.target_cidade
      r.add_field :estado_destino, @ordem_service.ordem_service_change.target_estado
      r.add_field :cep_destino, @ordem_service.ordem_service_change.target_cep
      r.add_field :contato_destino, @ordem_service.ordem_service_change.target_contato
      r.add_field :valor_servico, number_to_currency( @ordem_service.valor_ordem_service, unit: "R$ ", separator: ",", delimiter: ".")
      r.add_field :valor_seguro, number_to_currency( @ordem_service.ordem_service_change.valor_declarado, unit: "R$ ", separator: ",", delimiter: ".")
      r.add_field :os_numero, @ordem_service.id
      r.add_field :os_ano, @ordem_service.created_at.strftime('%Y')
  	end
  #report_file_name = report.generate
  name_report = "#{@ordem_service.id}-#{@ordem_service.client.nome}"
  puts ">>>>>>>>>>>>> #{name_report}"
 	send_data report.generate,
             type: 'application/vnd.oasis.opendocument.text',
             disposition: 'attachment',
             filename: "#{name_report}.odt"
  end

  def print_inventory
    @ordem_service = OrdemService.find(params[:id])
    @list_of_itens = @ordem_service.inventories
    report = ODFReport::Report.new("#{Rails.root}/app/reports/iventario_mudanca.odt") do |r|
      r.add_field :nome_do_cliente, @ordem_service.client.nome
      r.add_field :data_coleta, date_br(@ordem_service.data)
      r.add_field :prz_entrega, date_br(@ordem_service.ordem_service_change.date_limit)
      r.add_field :contato, @ordem_service.client.fone_all

      r.add_field :endereco_origem, @ordem_service.ordem_service_change.source_endereco +
                                    @ordem_service.ordem_service_change.source_numero
      r.add_field :field_aleatorio, @ordem_service.ordem_service_change.source_bairro
      r.add_field :cidade_origem, @ordem_service.ordem_service_change.source_cidade
      r.add_field :cep_origem, @ordem_service.ordem_service_change.source_cep
      r.add_field :contato_local, @ordem_service.ordem_service_change.source_contato
      r.add_field :campo_aleatorio, @ordem_service.ordem_service_change.source_estado

      r.add_field :endereco_destino, @ordem_service.ordem_service_change.target_endereco +
                                    @ordem_service.ordem_service_change.target_numero
      r.add_field :neighborhood_target, @ordem_service.ordem_service_change.target_bairro
      r.add_field :cidade_destino, @ordem_service.ordem_service_change.target_cidade
      r.add_field :cep_destino, @ordem_service.ordem_service_change.target_cep
      r.add_field :state_target, @ordem_service.ordem_service_change.target_estado
      r.add_field :os_numero, @ordem_service.id
      r.add_field :os_ano, @ordem_service.created_at.strftime('%Y')
      r.add_field :observacao, @ordem_service.observacao
      #r.add_field :number_id, "10"
      #r.add_field :description, "DESCRICAO DO PRODUTO"

      r.add_table("Tabela1", @list_of_itens, :header=>true) do |t|
        t.add_column(:numero, :numero) 
        t.add_column(:descricao, :descricao)
        t.add_column(:estado, :estado)
        t.add_column(:valor, :valor)
      end

    end
  #report_file_name = report.generate
  name_report = "Iventario-#{@ordem_service.id}-#{@ordem_service.client.nome}"
  puts ">>>>>>>>>>>>> #{name_report}"
  send_data report.generate,
             type: 'application/vnd.oasis.opendocument.text',
             disposition: 'attachment',
             filename: "#{name_report}.odt"
  end

end
