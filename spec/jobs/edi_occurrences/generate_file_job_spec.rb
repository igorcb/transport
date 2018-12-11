require 'rails_helper'
require 'sidekiq'
require 'sidekiq/testing'

RSpec.describe EdiOccurrences::GenerateFileJob, type: :job do
  include ActiveJob::TestHelper

  subject(:job) { EdiOccurrences::GenerateFileJob.perform_later }

  it { is_expected.to be_processed_in :edi_notfis }

  it 'queues the job' do
    expect { job }.to change(ActiveJob::Base.queue_adapter.enqueued_jobs, :size).by(1)
  end

  #criar uma ou mais ordem de servico com suas respectivas notas fiscais
  #fazer a baixa com a data do dia anterior

  # fazer um filtro de NF-e com a data da baixa do dia anterior
  #nfe_key = NfeKey.where(id: -1)
  # fazer um teste esperando que o filtro com a data anterior não retorne
  # fazer um teste que espera que tenha retornado o filtro

  # it "whan not return NF-e" do
  #
  # end

  context 'executes perform' do
    it 'whan not return NF-e' do
      perform_enqueued_jobs { job }
    end

    it 'whan return NF-e' do

      @date_delivery = Date.current - 1.day
      expect { FactoryBot.create(:ordem_service, data_entrega_servico: @date_delivery) }.to change{ OrdemService.count }.by(1)

      perform_enqueued_jobs { job }

      #retornar a query onde não tenha nfe para ser processada pelo edi_notfis
      expect(OrdemService.where(data_entrega_servico: Date.current + 5.day).count).to eq(0)

    end

  end

end
