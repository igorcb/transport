require 'rails_helper'

RSpec.describe InputControls::ConferenceItemService, type: :service do
  context "create" do
    before(:each) do
      byebug
      # @user = FactoryBot.create(:user)
      @input_control = FactoryBot.create(:input_control)
      @input_control_id = @input_control.id
    end

    it "when input_controls_id is not exist" do
      result = InputControls::ConferenceItemService.new(nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control id is not exist.")
    end

    it "when input_controls is not exist" do
      result = InputControls::ConferenceItemService.new(@input_control_id).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Input Control data is not exist.")
    end


  end

end
