require File.dirname(__FILE__) + '/../../config/environment.rb'

class ReportsController < ApplicationController
  include ApplicationHelper
  include ActionView::Helpers::NumberHelper
	def index
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
      r.add_field :client_nome, @ordem_service.client.nome
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
