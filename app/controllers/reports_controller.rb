require File.dirname(__FILE__) + '/../../config/environment.rb'

class ReportsController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
	def index
	end

  def print_billing
    @billing = Billing.find(params[:id])
    # For Rails 3 or latest replace #{RAILS_ROOT} to #{Rails.root}
    report = ODFReport::Report.new("#{Rails.root}/app/reports/fatura.odt") do |r|
      valor = (@billing.valor.to_f * 100)
      r.add_field(:vr_fatura, @billing.valor)
      r.add_field(:no_duplicata, @billing.id)
      r.add_field(:ano_duplicata, extract_year(@billing.data))
      r.add_field(:vencimento, date_br(@billing.data + 10.days))
      r.add_field(:emitida_em, date_br(@billing.data))
      r.add_field(:vr_total, @billing.valor)
      r.add_field(:valor_por_extenso, Extenso.moeda(valor)) #multiplicar por 100 para gerar as casas decimais
      @client = b.ordem_services.first.billing_client
      r.add_field(:nome_sacado, @client.nome)
      r.add_field(:endereco_sacado, "#{@client.endereco}, #{@client.numero}")
      r.add_field(:bairro_sacado, @client.bairro)
      r.add_field(:cidade_sacado, @client.cidade)
      r.add_field(:uf, @client.estado)
      r.add_field(:cnpj_sacado, @client.cpf_cnpj)
      r.add_field(:ie_sacado, @client.inscricao_estadual)




      # r.add_table("OPERATORS", @billing.ordem_services) do |t|
      #   # t.add_column(:motorista_id) {|os| "#{os.ordem_service_logistic.driver.nome}" }
      #   # t.add_column(:client_id) { |os| "#{os.client.nome}" }
      #   t.add_column(:placa_id) {|os| "#{os.ordem_service_logistic.placa}" }
      #   t.add_column(:vr_servico, :valor_ordem_service)
      #   t.add_column(:motorista_id, :motorista_nome)
      #   t.add_column(:client_id, :cliente_nome)
        
      # end
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
