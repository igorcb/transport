require 'rails_helper'

RSpec.describe "deposits/index", type: :view do
  before(:each) do
    assign(:deposits, [
      Deposit.create!(
        :warehouse => nil,
        :name => "Name"
      ),
      Deposit.create!(
        :warehouse => nil,
        :name => "Name"
      )
    ])
  end

  it "renders a list of deposits" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Name".to_s, :count => 2
  end
end
