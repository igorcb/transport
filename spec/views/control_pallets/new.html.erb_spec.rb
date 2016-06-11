require 'spec_helper'

describe "control_pallets/new" do
  before(:each) do
    assign(:control_pallet, stub_model(ControlPallet,
      :client => nil,
      :qte => 1,
      :tipo => 1,
      :historico => "MyString"
    ).as_new_record)
  end

  it "renders new control_pallet form" do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select "form", :action => control_pallets_path, :method => "post" do
      assert_select "input#control_pallet_client", :name => "control_pallet[client]"
      assert_select "input#control_pallet_qte", :name => "control_pallet[qte]"
      assert_select "input#control_pallet_tipo", :name => "control_pallet[tipo]"
      assert_select "input#control_pallet_historico", :name => "control_pallet[historico]"
    end
  end
end
