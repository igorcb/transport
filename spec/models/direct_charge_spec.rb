require 'rails_helper'

RSpec.describe DirectCharge, type: :model do
  let(:direct_charge) { FactoryBot.create(:direct_charge) }

  it 'is valid if all fields have value' do
    expect { direct_charge }.to change { DirectCharge.count }.by(1)
  end

  it "when place is not present" do
		direct_charge.place = nil
		expect(direct_charge.place).to be_falsey
	end

	it "when place is present" do
		direct_charge.place = 'HHH-0000'
		expect(direct_charge.place).to be_truthy
	end

end
