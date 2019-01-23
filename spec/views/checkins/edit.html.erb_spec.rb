require 'rails_helper'

RSpec.describe "checkins/edit", type: :view do
  before(:each) do
    @checkin = assign(:checkin, Checkin.create!(
      :driver => nil,
      :type => ""
    ))
  end

  it "renders the edit checkin form" do
    render

    assert_select "form[action=?][method=?]", checkin_path(@checkin), "post" do

      assert_select "input[name=?]", "checkin[driver_id]"

      assert_select "input[name=?]", "checkin[type]"
    end
  end
end
