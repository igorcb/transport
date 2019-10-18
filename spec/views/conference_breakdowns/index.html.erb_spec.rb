require 'rails_helper'

RSpec.describe "conference_breakdowns/index", type: :view do
  before(:each) do
    assign(:conference_breakdowns, [
      ConferenceBreakdown.create!(),
      ConferenceBreakdown.create!()
    ])
  end

  it "renders a list of conference_breakdowns" do
    render
  end
end
