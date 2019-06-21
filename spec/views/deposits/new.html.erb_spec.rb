require 'rails_helper'

RSpec.describe "deposits/new", type: :view do
  before(:each) do
    assign(:deposit, Deposit.new(
      :warehouse => nil,
      :name => "MyString"
    ))
  end

  it "renders new deposit form" do
    render

    assert_select "form[action=?][method=?]", deposits_path, "post" do

      assert_select "input[name=?]", "deposit[warehouse_id]"

      assert_select "input[name=?]", "deposit[name]"
    end
  end
end
