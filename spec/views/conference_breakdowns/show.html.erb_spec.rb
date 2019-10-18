require 'rails_helper'

RSpec.describe "conference_breakdowns/show", type: :view do
  before(:each) do
    @conference_breakdown = assign(:conference_breakdown, ConferenceBreakdown.create!())
  end

  it "renders attributes in <p>" do
    render
  end
end
