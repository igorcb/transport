require 'rails_helper'

RSpec.describe "conference_breakdowns/new", type: :view do
  before(:each) do
    assign(:conference_breakdown, ConferenceBreakdown.new())
  end

  it "renders new conference_breakdown form" do
    render

    assert_select "form[action=?][method=?]", conference_breakdowns_path, "post" do
    end
  end
end
