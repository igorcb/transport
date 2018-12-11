require 'rails_helper'

RSpec.describe EdiQueue, type: :model do
  #let(:address) { FactoryGirl.create(:address) }
  before do
    # nfe_key = FactoryBot.create(:nfe_key)
  	# @edi_queue = nfe_key.edi_queues.create!( status: 0 )
  end

  # subject { @edi_queue }
  #
  # it { should respond_to(:nfe_key) }
  # it { should respond_to(:status) }
  # it { should define_enum_for(:status).with([:not_proccess, :proccess]) }

  # it "validates the status" do
  #   expect(@edi_queue.status).to be_valid
  # end
end
