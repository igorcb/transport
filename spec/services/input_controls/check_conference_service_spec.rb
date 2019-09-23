require 'rails_helper'

RSpec.describe InputControls::CheckConferenceService, type: :service do
  context "check" do
    before(:each) do
      # byebug
      @user = FactoryBot.create(:user)
      @group_client = FactoryBot.create(:group_client)
      @input_control = FactoryBot.create(:input_control)
      # @conference = FactoryBot.create(:conference)
    end

    it "when input control is not present" do
      result = InputControls::CheckConferenceService.new(nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("ERROR: input control is not present.")
    end

    it "when conference is not found" do
      result = InputControls::CheckConferenceService.new(@input_control).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("ERROR: @conference is not found.")
    end

  end

end
