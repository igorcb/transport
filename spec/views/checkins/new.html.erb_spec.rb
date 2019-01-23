require 'rails_helper'

RSpec.describe "checkins/new", type: :view do
  before(:each) do
    assign(:checkin, Checkin.new(
      :driver => nil,
      :type => ""
    ))
  end

  it "renders new checkin form" do
    render

    assert_select "form[action=?][method=?]", checkins_path, "post" do

      assert_select "input[name=?]", "checkin[driver_id]"

      assert_select "input[name=?]", "checkin[type]"
    end
  end
end
