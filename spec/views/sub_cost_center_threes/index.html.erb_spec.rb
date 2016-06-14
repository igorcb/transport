require 'spec_helper'

describe "sub_cost_center_threes/index" do
  before(:each) do
    assign(:sub_cost_center_threes, [
      stub_model(SubCostCenterThree,
        :cost_center => nil,
        :sub_cost_center => nil,
        :descricao => "Descricao"
      ),
      stub_model(SubCostCenterThree,
        :cost_center => nil,
        :sub_cost_center => nil,
        :descricao => "Descricao"
      )
    ])
  end

  it "renders a list of sub_cost_center_threes" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Descricao".to_s, :count => 2
  end
end
