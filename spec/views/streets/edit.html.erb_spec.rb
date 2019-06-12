require 'rails_helper'

RSpec.describe "streets/edit", type: :view do
  before(:each) do
    @street = assign(:street, Street.create!(
      :name => "MyString",
      :deposit => nil
    ))
  end

  it "renders the edit street form" do
    render

    assert_select "form[action=?][method=?]", street_path(@street), "post" do

      assert_select "input[name=?]", "street[name]"

      assert_select "input[name=?]", "street[deposit_id]"
    end
  end
end
