require 'rails_helper'
require 'spec_helper'
require 'fileutils'

RSpec.describe EdiOccurrences::GenerateFileService, type: :service do
  describe "#call" do
    before(:each) do

    end

    context "return msg nfe not select" do
      it "when not exist params NFe" do
        result = EdiOccurrences::GenerateFileService.new([]).call
        #expect(result).to match('Select one nfe')
        expect(result[:error]).to be_falsey
        expect(result[:message]).to match("Select one nfe")
      end
    end

    context "return msg nfe select" do
      it "when exist params NFe" do
        nfe_key = NfeKey.first
        ordem_service = nfe_key.ordem_service
        input_control = ordem_service.input_control

        ordem_service.billing_client_id = input_control.billing_client_id
        ordem_service.data_entrega_servico = Date.current
        nfe_key.ordem_service.save!
        nfe_key.reload

        result = EdiOccurrences::GenerateFileService.new([nfe_key.id]).call
        #expect(result).to match('File generate success')
        expect(result[:success]).to be_truthy
        expect(result[:message]).to match("File generate success")

        file_path = Rails.root.join('public/system/file_edi', result[:name_file])

        expect(File.exists?(file_path)).to be_truthy
      end

    end
  end

  def get_hash_ids
    hash = {}
    hash_ids = {}
    hash_key_value = {}

    key = 1 #nfe_xml.id.to_s
    value = 1 #nfe_xml.id.to_s

    hash_key_value.store(key, value)
    hash_ids.store(:ids, hash_key_value)

    hash.store(:id, 1)
    hash.store(:nfe, hash_ids)
  end
end
