require 'rails_helper'

RSpec.describe Checkins::DestroyService, type: :service do
  context "destroy" do
    before(:each) do
      @checkin = FactoryBot.create(:checkin)
    end

    it "when checkin is not present" do
      checkin = Checkins::DestroyService.new(nil).call
      expect(checkin[:success]).to be_falsey
    end

    it "when checkin was deleted success" do
      checkin = Checkins::DestroyService.new(@checkin).call
      expect(checkin[:success]).to be_truthy
    end

  end

end
