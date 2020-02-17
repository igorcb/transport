require 'rails_helper'

RSpec.describe Checkins::DestroyService, type: :service do
  context "destroy" do
    before(:each) do
      @checkin = FactoryBot.create(:checkin)
    end

    it "when checkin is not present" do
      result = Checkins::DestroyService.new(nil).call
      expect(result[:success]).to be_falsey
    end

    it "when checkin is not associated" do
      @checkin.update_attributes(operation_id: nil)
      result = Checkins::DestroyService.new(@checkin).call
      expect(result[:success]).to be_falsey
    end

    context "actions" do
      it "create Event" do
        # event_count = Event.count
        @checkin.update_attributes(operation_id: 1)
        #result = Checkins::DestroyService.new(@checkin).call
        # expect(Event.count > event_count).to be_truthy
        expect { Checkins::DestroyService.new(@checkin).call }.to change { Event.count }.by(1)
      end

      it "deleted success" do
        @checkin.update_attributes(operation_id: 1)
        result = Checkins::DestroyService.new(@checkin).call
        expect(result[:success]).to be_truthy
      end      
    end


  end

end
