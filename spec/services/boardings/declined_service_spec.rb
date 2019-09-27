require 'rails_helper'

RSpec.describe Boardings::Declined, type: :service do

  context "generate" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @ordem_service_first = FactoryBot.create(:ordem_service)
      @ordem_service_second = FactoryBot.create(:ordem_service)
      @ordem_service_third = FactoryBot.create(:ordem_service)
      @ordem_service_ids = [@ordem_service_first.id, @ordem_service_second.id, @ordem_service_third.id]
    end

    it "when user is not exist" do
      # result = Boardings::GenerateService.new(nil, nil).call
      # expect(result[:success]).to be_falsey
      # expect(result[:message]).to match("User not information.")
    end

  end
end
