require 'rails_helper'

RSpec.describe "warehouses/edit", type: :view do
  before(:each) do
    @warehouse = assign(:warehouse, Warehouse.create!(
      :name => "MyString",
      :address => "MyString",
      :number => "MyString",
      :district => "MyString",
      :city => "MyString",
      :state => "MyString",
      :zip_code => "MyString"
    ))
  end

  it "renders the edit warehouse form" do
    render

    assert_select "form[action=?][method=?]", warehouse_path(@warehouse), "post" do

      assert_select "input[name=?]", "warehouse[name]"

      assert_select "input[name=?]", "warehouse[address]"

      assert_select "input[name=?]", "warehouse[number]"

      assert_select "input[name=?]", "warehouse[district]"

      assert_select "input[name=?]", "warehouse[city]"

      assert_select "input[name=?]", "warehouse[state]"

      assert_select "input[name=?]", "warehouse[zip_code]"
    end
  end
end
