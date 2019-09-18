require 'rails_helper'

RSpec.describe Boardings::GenerateService, type: :service do

  context "generate" do
    before(:each) do
      #byebug
      #@user = FactoryBot.create(:user)
      @ordem_service_first = FactoryBot.create(:ordem_service)
      @ordem_service_second = FactoryBot.create(:ordem_service)
      @ordem_service_third = FactoryBot.create(:ordem_service)
      @ordem_service_ids = [@ordem_service_first.id, @ordem_service_second.id, @ordem_service_ids.id]
    end

    it "when there is no ordem service" do
      result = Boardings::GenerateService.new(nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Ordem Service not selected.")
    end

    it "when exist ordem service" do
      result = Boardings::GenerateService.new(@ordem_service_ids).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Ordem Service not selected.")
    end

  end
end
