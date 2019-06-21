require 'rails_helper'

RSpec.describe "houses/index", type: :view do
  before(:each) do
    assign(:houses, [
      House.create!(
        :name => "Name",
        :floor => nil
      ),
      House.create!(
        :name => "Name",
        :floor => nil
      )
    ])
  end

  it "renders a list of houses" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => nil.to_s, :count => 2
  end
end
