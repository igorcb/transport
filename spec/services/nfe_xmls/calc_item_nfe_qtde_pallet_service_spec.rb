require 'rails_helper'

RSpec.describe NfeXmls::CalcItemNfeQtdePalletService, type: :service do
  describe "#call" do
    before(:each) do
      # @user = User.first
      #@nfe_xml = FactoryBot.create(:nfe_xml)
      #@product = Product.last
      @product = FactoryBot.create(:product)
      @qtde = 210
    end

    it "when product not exist" do
      result = NfeXmls::CalcItemNfeQtdePalletService.new(nil, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Product is not blank.")
    end

    it "when product exist" do
      @product.update_attributes(box_by_pallet: @qtde)
      result = NfeXmls::CalcItemNfeQtdePalletService.new(@product, @qtde).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Calculation successful.")
    end

    it "when product exist and box_by_pallet is blank" do
      @product.update_attributes(box_by_pallet: nil)
      result = NfeXmls::CalcItemNfeQtdePalletService.new(@product, @qtde).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Product, box_by_pallet is not blank.")
    end

    it "when product exist and box_by_pallet is present" do
      @product.update_attributes(box_by_pallet: @qtde)
      result = NfeXmls::CalcItemNfeQtdePalletService.new(@product, @qtde).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Calculation successful.")
    end

    #
    # it "when nfe_xml exist and qtde_pallet informed" do
    #   result = NfeXmls::CalcItemNfeQtdePalletService.new(@nfe_xml, @qtde_pallet).call
    #   expect(@nfe_xml.reload.qtde_pallet).to equal(@qtde_pallet)
    #   expect(result[:success]).to be_truthy
    #   expect(result[:message]).to match("Qtde de Pallet information successfully.")
    # end
  end
end
