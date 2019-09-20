require 'rails_helper'

RSpec.describe Conferences::ConferenceItemCreateService, type: :service do
  context "create" do
    before(:each) do
      #byebug
      @input_control = FactoryBot.create(:input_control)
      @product = FactoryBot.create(:product)
    end

    it "when input_control_id is not found" do
      result = Conferences::ConferenceItemCreateService.new({input_control: @input_control}).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("conference_id is not found.")
    end

  end

end
