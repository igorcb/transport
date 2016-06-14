require 'spec_helper'

describe "sub_cost_center_threes/new" do
  before(:each) do
    assign(:sub_cost_center_three, stub_model(SubCostCenterThree,
      :cost_center => nil,
      :sub_cost_center => nil,
      :descricao => "MyString"
    ).as_new_record)
  end

  it "renders new sub_cost_center_three form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => sub_cost_center_threes_path, :method => "post" do
      assert_select "input#sub_cost_center_three_cost_center", :name => "sub_cost_center_three[cost_center]"
      assert_select "input#sub_cost_center_three_sub_cost_center", :name => "sub_cost_center_three[sub_cost_center]"
      assert_select "input#sub_cost_center_three_descricao", :name => "sub_cost_center_three[descricao]"
    end
  end
end
