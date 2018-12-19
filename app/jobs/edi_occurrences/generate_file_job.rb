require 'sidekiq'
require 'sidekiq-scheduler'
# Todos os dias as 10h da manhã o sistema deve fazer um filtro de todas as NF-e
# que foram dado baixa no dia anterior, processsar o arquivo edi_notfis e enviar
# um email.

class EdiOccurrences::GenerateFileJob < ApplicationJob
  queue_as :edi_notfis

  def perform(*args)
    # Processar o Arquivo
    # GroupClient 10 = Quimica Amparo
    ype_cnpj = GroupClient.find(10).clients.pluck(:cpf_cnpj)
    ype_cnpj.each do |cnpj|
      # Somente notas dos CNPJ da Quimica Amparo
      nfe_keys = EdiQueue.joins(nfe_key: [ordem_service: [:billing_client]]).where(status: 0).where("clients.cpf_cnpj = ?", cnpj).pluck(:nfe_key_id)
      if !nfe_keys.blank?
        puts ">>>>>>>>>>>>>>>>>>>>>>>> Chama o Service"
        result = EdiOccurrences::GenerateFileService.new(nfe_keys).call
        # Enviar o email
        file = File.read(Rails.root.join('public/system/file_edi', result[:name_file]))
        EdiNotfisMailer.notification(result[:name_file], file).deliver_now
      end
    end

  end
end
