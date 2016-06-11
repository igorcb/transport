require 'spec_helper'

describe "control_pallets/show" do
  before(:each) do
    @control_pallet = assign(:control_pallet, stub_model(ControlPallet,
      :client => nil,
      :qte => 1,
      :tipo => 2,
      :historico => "Historico"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(/1/)
    rendered.should match(/2/)
    rendered.should match(/Historico/)
  end
end
