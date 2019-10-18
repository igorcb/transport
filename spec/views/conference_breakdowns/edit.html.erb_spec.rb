require 'rails_helper'

RSpec.describe "conference_breakdowns/edit", type: :view do
  before(:each) do
    @conference_breakdown = assign(:conference_breakdown, ConferenceBreakdown.create!())
  end

  it "renders the edit conference_breakdown form" do
    render

    assert_select "form[action=?][method=?]", conference_breakdown_path(@conference_breakdown), "post" do
    end
  end
end
