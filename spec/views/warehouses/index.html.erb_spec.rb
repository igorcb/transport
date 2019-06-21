require 'rails_helper'

RSpec.describe "warehouses/index", type: :view do
  before(:each) do
    assign(:warehouses, [
      Warehouse.create!(
        :name => "Name",
        :address => "Address",
        :number => "Number",
        :district => "District",
        :city => "City",
        :state => "State",
        :zip_code => "Zip Code"
      ),
      Warehouse.create!(
        :name => "Name",
        :address => "Address",
        :number => "Number",
        :district => "District",
        :city => "City",
        :state => "State",
        :zip_code => "Zip Code"
      )
    ])
  end

  it "renders a list of warehouses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Address".to_s, :count => 2
    assert_select "tr>td", :text => "Number".to_s, :count => 2
    assert_select "tr>td", :text => "District".to_s, :count => 2
    assert_select "tr>td", :text => "City".to_s, :count => 2
    assert_select "tr>td", :text => "State".to_s, :count => 2
    assert_select "tr>td", :text => "Zip Code".to_s, :count => 2
  end
end
