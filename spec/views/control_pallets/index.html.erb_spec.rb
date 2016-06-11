require 'spec_helper'

describe "control_pallets/index" do
  before(:each) do
    assign(:control_pallets, [
      stub_model(ControlPallet,
        :client => nil,
        :qte => 1,
        :tipo => 2,
        :historico => "Historico"
      ),
      stub_model(ControlPallet,
        :client => nil,
        :qte => 1,
        :tipo => 2,
        :historico => "Historico"
      )
    ])
  end

  it "renders a list of control_pallets" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => 1.to_s, :count => 2
    assert_select "tr>td", :text => 2.to_s, :count => 2
    assert_select "tr>td", :text => "Historico".to_s, :count => 2
  end
end
