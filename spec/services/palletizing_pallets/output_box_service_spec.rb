require 'rails_helper'

RSpec.describe PalletizingPallets::OutputBoxService, type: :service do
  context "remove output box" do
    before(:each)  do
      @user = @product = FactoryBot.create(:user)
      @pallet = FactoryBot.create(:palletizing_pallet)
    end
    it "when pallet is nil" do
      result = PalletizingPallets::OutputBoxService.new(nil, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Pallet can't be nil")
    end
    it "when user is nil" do
      result = PalletizingPallets::OutputBoxService.new(@pallet, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("User can't be nil")
    end
  end
end