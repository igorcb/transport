require 'spec_helper'

describe "sub_cost_center_threes/show" do
  before(:each) do
    @sub_cost_center_three = assign(:sub_cost_center_three, stub_model(SubCostCenterThree,
      :cost_center => nil,
      :sub_cost_center => nil,
      :descricao => "Descricao"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    rendered.should match(//)
    rendered.should match(//)
    rendered.should match(/Descricao/)
  end
end
