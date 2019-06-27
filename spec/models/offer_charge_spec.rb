require 'rails_helper'

RSpec.describe OfferCharge, type: :model do
  let(:offer_charge) { FactoryBot.create(:offer_charge) }

  it 'is valid if all fields have value' do
    expect { offer_charge }.to change { OfferCharge.count }.by(1)
  end

  # it "when place is not present" do
	# 	direct_charge.place = nil
	# 	expect(direct_charge.place).to be_falsey
	# end
  #
	# it "when place is present" do
	# 	direct_charge.place = 'HHH-0000'
	# 	expect(direct_charge.place).to be_truthy
	# end

end
