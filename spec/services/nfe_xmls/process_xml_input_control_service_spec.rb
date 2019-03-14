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
        path = "/home/igor#{Rails.root.join('public/system')}" + '/nfe_xmls/assets/000/000/001/original/29170343461789000514550020001747381419179629.xml'
        puts ">>>>>>>>>>>>>>>>>>>>>>>> PATH: #{path}"
        @nfe_xml = NfeXml.create(status: :processado, asset: File.open(path))
      end

      it "when not exist nfe_xml" do
        result = NfeXmls::ProcessXmlInputControlService.new('').call
        #expect(result).to match('Select one nfe')
        expect(result[:error]).to be_falsey
        expect(result[:message]).to match("NF-e XML not blank.")
      end

      context "when exist xml" do
        it "and not exist attachment" do
          result = NfeXmls::ProcessXmlInputControlService.new(@nfe_xml).call
          expect(result[:error]).to be_falsey
          expect(result[:message]).to match("NF-e XML not blank.")
        end

        it "is already processed" do
          result = NfeXmls::ProcessXmlInputControlService.new(@nfe_xml).call
          expect(result[:error]).to be_falsey
          expect(result[:message]).to match("NFe Xml já processado.")
        end
      end
    end

  end
end
