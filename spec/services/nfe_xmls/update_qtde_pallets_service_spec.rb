require 'rails_helper'

RSpec.describe NfeXmls::UpdateQtdePalletsService, type: :service do
  describe "#call" do
    before(:each) do
      # @user = User.first
      #@nfe_xml = FactoryBot.create(:nfe_xml)
      @nfe_xml = NfeXml.last
      @qtde_pallet = 1
    end

    it "when nfe_xml not exist" do
      result = NfeXmls::UpdateQtdePalletsService.new(nil, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("NF-e XML is not exist.")
    end

    it "when nfe_xml exist and qtde_pallet not informed" do
      result = NfeXmls::UpdateQtdePalletsService.new(@nfe_xml, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Qtde Pallets is not present.")
    end

    it "when nfe_xml exist and qtde_pallet is 0 (zero)" do
      result = NfeXmls::UpdateQtdePalletsService.new(@nfe_xml, 0).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Qtde Pallets must be greater than 0 (zero).")
    end

    it "when nfe_xml exist and qtde_pallet informed" do
      result = NfeXmls::UpdateQtdePalletsService.new(@nfe_xml, @qtde_pallet).call
      expect(@nfe_xml.reload.qtde_pallet).to equal(@qtde_pallet)
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Qtde de Pallet information successfully.")
    end
  end
end
