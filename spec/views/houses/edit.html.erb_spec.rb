require 'rails_helper'

RSpec.describe "houses/edit", type: :view do
  before(:each) do
    @house = assign(:house, House.create!(
      :name => "MyString",
      :floor => nil
    ))
  end

  it "renders the edit house form" do
    render

    assert_select "form[action=?][method=?]", house_path(@house), "post" do

      assert_select "input[name=?]", "house[name]"

      assert_select "input[name=?]", "house[floor_id]"
    end
  end
end
