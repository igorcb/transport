require 'rails_helper'

RSpec.describe "streets/show", type: :view do
  before(:each) do
    @street = assign(:street, Street.create!(
      :name => "Name",
      :deposit => nil
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(//)
  end
end
