require 'rails_helper'

RSpec.describe Boarding, type: :model do
  let(:boarding) { FactoryBot.create(:boarding) }

  it 'is valid if all fields have value' do
    expect { boarding }.to change { Boarding.count }.by(1)
  end
end
