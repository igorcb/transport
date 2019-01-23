require 'rails_helper'

RSpec.describe "checkins/index", type: :view do
  before(:each) do
    assign(:checkins, [
      Checkin.create!(
        :driver => nil,
        :type => "Type"
      ),
      Checkin.create!(
        :driver => nil,
        :type => "Type"
      )
    ])
  end

  it "renders a list of checkins" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
  end
end
