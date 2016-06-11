require 'spec_helper'

describe "control_pallets/edit" do
  before(:each) do
    @control_pallet = assign(:control_pallet, stub_model(ControlPallet,
      :client => nil,
      :qte => 1,
      :tipo => 1,
      :historico => "MyString"
    ))
  end

  it "renders the edit control_pallet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => control_pallets_path(@control_pallet), :method => "post" do
      assert_select "input#control_pallet_client", :name => "control_pallet[client]"
      assert_select "input#control_pallet_qte", :name => "control_pallet[qte]"
      assert_select "input#control_pallet_tipo", :name => "control_pallet[tipo]"
      assert_select "input#control_pallet_historico", :name => "control_pallet[historico]"
    end
  end
end
