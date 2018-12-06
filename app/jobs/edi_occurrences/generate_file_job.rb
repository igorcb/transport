require 'sidekiq'

# Todos os dias as 10h da manhã o sistema deve fazer um filtro de todas as NF-e
# que foram dado baixa no dia anterior, processsar o arquivo edi_notfis e enviar
# um email.

class EdiOccurrences::GenerateFileJob < ApplicationJob
  queue_as :edi_notfis

  def perform(*args)
    true
  end
end
