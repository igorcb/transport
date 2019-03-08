require 'rails_helper'

RSpec.describe NfeXmls::ProcessXmlInputControlService, type: :service do
  describe "#call" do
    before(:each) do
      # @user = User.first
      # @boarding = OrdemService.first.boarding
      # @ordem_service = OrdemService.first
      # @ordem_service_other = OrdemService.last
    end

    context "process xml" do
      before(:each) do
        #@update_delivery = update_delivery_service(@ordem_service, @user)
      end

      it "when not exist xml" do
        result = NfeXmls::ProcessXmlInputControlService.new('').call
        #expect(result).to match('Select one nfe')
        expect(result[:error]).to be_falsey
        expect(result[:message]).to match("NF-e XML not blank.")
      end

      it "when not exist xml" do
        result = NfeXmls::ProcessXmlInputControlService.new(NfeXml.last).call
        #expect(result).to match('Select one nfe')
        expect(result[:error]).to be_falsey
        expect(result[:message]).to match("NF-e XML not blank.")
      end
    end

  end
end
