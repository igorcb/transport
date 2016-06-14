require 'spec_helper'

describe "sub_cost_center_threes/edit" do
  before(:each) do
    @sub_cost_center_three = assign(:sub_cost_center_three, stub_model(SubCostCenterThree,
      :cost_center => nil,
      :sub_cost_center => nil,
      :descricao => "MyString"
    ))
  end

  it "renders the edit sub_cost_center_three form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sub_cost_center_threes_path(@sub_cost_center_three), :method => "post" do
      assert_select "input#sub_cost_center_three_cost_center", :name => "sub_cost_center_three[cost_center]"
      assert_select "input#sub_cost_center_three_sub_cost_center", :name => "sub_cost_center_three[sub_cost_center]"
      assert_select "input#sub_cost_center_three_descricao", :name => "sub_cost_center_three[descricao]"
    end
  end
end
