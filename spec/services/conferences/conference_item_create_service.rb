require 'rails_helper'

RSpec.describe Conferences::ConferenceItemCreateService, type: :service do
  context "create" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @input_control = FactoryBot.create(:input_control)
      @product = FactoryBot.create(:product)
      @item_input_control = FactoryBot.create(:item_input_control)
      @conference = FactoryBot.create(:conference)
    end

    it "when conference_id is not found" do
      result = Conferences::ConferenceItemCreateService.new({conference_id: @conference.id}).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("conference_id is not found.")
    end

  end

end
