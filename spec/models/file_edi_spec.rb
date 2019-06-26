require 'rails_helper'

RSpec.describe FileEdi, type: :model do
  before do
    # nfe_key = FactoryBot.create(:nfe_key)
  	# @edi_queue = nfe_key.edi_queues.create!( status: 0 )
  end
  let(:file_edi_occurrence) { FactoryBot.create(:file_edi_occurrence) }

  # subject { @edi_queue }
  #
  # it { should respond_to(:nfe_key) }
  # it { should respond_to(:status) }
  # it { should define_enum_for(:status).with([:not_proccess, :proccess]) }

  # it "validates the status" do
  #   expect(@edi_queue.status).to be_valid
  # end

  it 'is valid if all fields have value' do
    expect { file_edi_occurrence }.to change { FileEdi.count }.by(1)
  end
end
