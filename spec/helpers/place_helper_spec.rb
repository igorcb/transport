# require '../place_helper'
#
# RSpec.configure do |config|
#   config.include PlaceHelper
# end

describe "Place Helper" do
  before(:each) do
    @place = PlaceHelper.faker_place
  end

  it { expect(@place.length).to be(8) }
  it { expect(@place[0..2]).to be_kind_of(String) }
  it { expect(@place[4..8].to_i).to be_kind_of(Integer) }
  it "should regex match place tree letters and four number" do
    expect(@place).to match(/[a-zA-Z]{3}\-\d{4}/)
  end
end
