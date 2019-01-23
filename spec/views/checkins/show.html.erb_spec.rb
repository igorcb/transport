require 'rails_helper'

RSpec.describe "checkins/show", type: :view do
  before(:each) do
    @checkin = assign(:checkin, Checkin.create!(
      :driver => nil,
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Type/)
  end
end
