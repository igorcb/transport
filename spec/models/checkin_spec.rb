require 'rails_helper'

RSpec.describe Checkin, type: :model do
  let(:checkin) { FactoryBot.create(:checkin) }

  it 'is valid if all fields have value' do
    expect { checkin }.to change { Checkin.count }.by(1)
  end
end
