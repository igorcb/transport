require 'rails_helper'

RSpec.describe "houses/new", type: :view do
  before(:each) do
    assign(:house, House.new(
      :name => "MyString",
      :floor => nil
    ))
  end

  it "renders new house form" do
    render

    assert_select "form[action=?][method=?]", houses_path, "post" do

      assert_select "input[name=?]", "house[name]"

      assert_select "input[name=?]", "house[floor_id]"
    end
  end
end
