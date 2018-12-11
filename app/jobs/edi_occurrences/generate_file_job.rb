require 'sidekiq'
require 'sidekiq-scheduler'
# Todos os dias as 10h da manhã o sistema deve fazer um filtro de todas as NF-e
# que foram dado baixa no dia anterior, processsar o arquivo edi_notfis e enviar
# um email.

class EdiOccurrences::GenerateFileJob < ApplicationJob
  queue_as :edi_notfis

  def perform(*args)
    # Processar o Arquivo
    # Test Development
    nfe_key = NfeKey.where(nfe: '216952').first
    # Test Test
    nfe_key = NfeKey.last
    puts ">>>>>>>>>>>>>>>>>>>NfeKey: #{nfe_key.ordem_service.billing_client.cpf_cnpj }"
    result = EdiOccurrences::GenerateFileService.new([nfe_key.id]).call
    # Enviar o email
    file = File.read(Rails.root.join('public/system/file_edi', result[:name_file]))
    EdiNotfisMailer.notification(result[:name_file], file).deliver_now
  end
end
