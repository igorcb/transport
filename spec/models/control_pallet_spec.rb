require 'rails_helper'

#describe ControlPallet do
RSpec.describe ControlPallet, type: :model do

  before do
    @control_pallet = FactoryBot.build(:control_pallet)
  end

  subject { @control_pallet }

  it { should respond_to(:data) }
  it { should respond_to(:qte) }
  it { should respond_to(:tipo) }
  it { should respond_to(:historico) }
  it { should respond_to(:status) }
  it { should respond_to(:type_product) }

  describe "when responsible_type is not present" do
    before { @control_pallet.responsible_type = '' }
    it { should_not be_valid }
  end

  describe "when responsible_type is present" do
    before { @control_pallet.responsible_type = :driver }
    it { should be_valid }
  end
end
