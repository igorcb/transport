require 'rails_helper'

RSpec.describe "floors/index", type: :view do
  before(:each) do
    assign(:floors, [
      Floor.create!(
        :name => "Name",
        :street => nil
      ),
      Floor.create!(
        :name => "Name",
        :street => nil
      )
    ])
  end

  it "renders a list of floors" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
