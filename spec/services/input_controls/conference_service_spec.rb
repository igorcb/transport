require 'rails_helper'

RSpec.describe InputControls::ConferenceService, type: :service do
  context "create" do
    before(:each) do
      #byebug
      @user = FactoryBot.create(:user)
      @input_control = FactoryBot.create(:input_control)
    end

    it "when input_controls and user is not exist" do
      result = InputControls::ConferenceService.new(nil, nil).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control and user is not exist.")
    end

    it "when input_controls and user exist" do
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      result = InputControls::ConferenceService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Conference on input_control created successfully.")
    end

    it "when input_controls status is not DISCHARGE" do
      @input_control.update_attributes(status: InputControl::TypeStatus::OPEN)
      result = InputControls::ConferenceService.new(@input_control, @user).call
      expect(result[:success]).to be_falsey
      expect(result[:message]).to match("Input Control is not status DISCHARGE.")
    end

    it "when input_controls is DISCHARGE" do
      @input_control.update_attributes(status: InputControl::TypeStatus::DISCHARGE)
      result = InputControls::ConferenceService.new(@input_control, @user).call
      expect(result[:success]).to be_truthy
      expect(result[:message]).to match("Conference on input_control created successfully.")
    end

  end

end
