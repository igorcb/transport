require 'rails_helper'

RSpec.describe "floors/edit", type: :view do
  before(:each) do
    @floor = assign(:floor, Floor.create!(
      :name => "MyString",
      :street => nil
    ))
  end

  it "renders the edit floor form" do
    render

    assert_select "form[action=?][method=?]", floor_path(@floor), "post" do

      assert_select "input[name=?]", "floor[name]"

      assert_select "input[name=?]", "floor[street_id]"
    end
  end
end
