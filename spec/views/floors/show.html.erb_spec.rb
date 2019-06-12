require 'rails_helper'

RSpec.describe "floors/show", type: :view do
  before(:each) do
    @floor = assign(:floor, Floor.create!(
      :name => "Name",
      :street => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
