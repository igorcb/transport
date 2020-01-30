require 'rails_helper'

RSpec.describe "devolutions/new", type: :view do
  before(:each) do
    assign(:devolution, Devolution.new(
      :carrier_id => "MyString",
      :references, => "MyString",
      :driver_id => "MyString",
      :references, => "MyString",
      :billing_client_id => "MyString",
      :references, => "MyString",
      :place => "MyString",
      :string, => "MyString",
      :place_horse => "MyString",
      :string, => "MyString",
      :place_cart_1 => "MyString",
      :string, => "MyString",
      :date_entry => "MyString",
      :date, => "MyString",
      :time_entry => "MyString",
      :time, => "MyString",
      :date_receipt => "MyString",
      :date, => "MyString",
      :date_closing => "MyString",
      :date, => "MyString",
      :date_scheduled => "MyString",
      :date, => "MyString",
      :time_scheduled => "MyString",
      :time, => "MyString",
      :motive_scheduled => "MyString",
      :text, => "MyString",
      :palletized => "MyString",
      :boolean, => "MyString",
      :quantity_pallets => "MyString",
      :integer, => "MyString",
      :weight => "MyString",
      :decimal, => "MyString",
      :volume => "MyString",
      :decimal, => "MyString",
      :value_ton => "MyString",
      :decimal, => "MyString",
      :value_kg => "MyString",
      :decimal, => "MyString",
      :value_total => "MyString",
      :decimal, => "MyString",
      :charge_discharge => "MyString",
      :boolean, => "MyString",
      :shipment => "MyString",
      :string, => "MyString",
      :team => "MyString",
      :integer, => "MyString",
      :dock => "MyString",
      :integer, => "MyString",
      :hangar => "",
      :container => "MyString",
      :string, => "MyString",
      :place_confirmed => "MyString",
      :string, => "MyString",
      :start_time_discharge => "MyString",
      :datetime, => "MyString",
      :finish_time_discharge => "MyString",
      :datetime, => "MyString",
      :started_user_id => "MyString",
      :integer, => "MyString",
      :charge_type_delivery => "MyString",
      :integer, => "MyString",
      :date_start_avaria => "MyString",
      :date, => "MyString",
      :date_finish_avaria => "MyString",
      :date, => "MyString",
      :time_start_avaria => "MyString",
      :time, => "MyString",
      :time_finish_avaria => "MyString",
      :time, => "MyString",
      :status => "MyString",
      :integer, => "MyString",
      :user_id => "MyString",
      :references, => "MyString",
      :received_user_id => "MyString",
      :references, => "MyString",
      :breakdown_user_id => "MyString",
      :references, => "MyString",
      :observation => "MyString",
      :text => "MyString"
    ))
  end

  it "renders new devolution form" do
    render

    assert_select "form[action=?][method=?]", devolutions_path, "post" do

      assert_select "input[name=?]", "devolution[carrier_id]"

      assert_select "input[name=?]", "devolution[references,]"

      assert_select "input[name=?]", "devolution[driver_id]"

      assert_select "input[name=?]", "devolution[references,]"

      assert_select "input[name=?]", "devolution[billing_client_id]"

      assert_select "input[name=?]", "devolution[references,]"

      assert_select "input[name=?]", "devolution[place]"

      assert_select "input[name=?]", "devolution[string,]"

      assert_select "input[name=?]", "devolution[place_horse]"

      assert_select "input[name=?]", "devolution[string,]"

      assert_select "input[name=?]", "devolution[place_cart_1]"

      assert_select "input[name=?]", "devolution[string,]"

      assert_select "input[name=?]", "devolution[date_entry]"

      assert_select "input[name=?]", "devolution[date,]"

      assert_select "input[name=?]", "devolution[time_entry]"

      assert_select "input[name=?]", "devolution[time,]"

      assert_select "input[name=?]", "devolution[date_receipt]"

      assert_select "input[name=?]", "devolution[date,]"

      assert_select "input[name=?]", "devolution[date_closing]"

      assert_select "input[name=?]", "devolution[date,]"

      assert_select "input[name=?]", "devolution[date_scheduled]"

      assert_select "input[name=?]", "devolution[date,]"

      assert_select "input[name=?]", "devolution[time_scheduled]"

      assert_select "input[name=?]", "devolution[time,]"

      assert_select "input[name=?]", "devolution[motive_scheduled]"

      assert_select "input[name=?]", "devolution[text,]"

      assert_select "input[name=?]", "devolution[palletized]"

      assert_select "input[name=?]", "devolution[boolean,]"

      assert_select "input[name=?]", "devolution[quantity_pallets]"

      assert_select "input[name=?]", "devolution[integer,]"

      assert_select "input[name=?]", "devolution[weight]"

      assert_select "input[name=?]", "devolution[decimal,]"

      assert_select "input[name=?]", "devolution[volume]"

      assert_select "input[name=?]", "devolution[decimal,]"

      assert_select "input[name=?]", "devolution[value_ton]"

      assert_select "input[name=?]", "devolution[decimal,]"

      assert_select "input[name=?]", "devolution[value_kg]"

      assert_select "input[name=?]", "devolution[decimal,]"

      assert_select "input[name=?]", "devolution[value_total]"

      assert_select "input[name=?]", "devolution[decimal,]"

      assert_select "input[name=?]", "devolution[charge_discharge]"

      assert_select "input[name=?]", "devolution[boolean,]"

      assert_select "input[name=?]", "devolution[shipment]"

      assert_select "input[name=?]", "devolution[string,]"

      assert_select "input[name=?]", "devolution[team]"

      assert_select "input[name=?]", "devolution[integer,]"

      assert_select "input[name=?]", "devolution[dock]"

      assert_select "input[name=?]", "devolution[integer,]"

      assert_select "input[name=?]", "devolution[hangar]"

      assert_select "input[name=?]", "devolution[container]"

      assert_select "input[name=?]", "devolution[string,]"

      assert_select "input[name=?]", "devolution[place_confirmed]"

      assert_select "input[name=?]", "devolution[string,]"

      assert_select "input[name=?]", "devolution[start_time_discharge]"

      assert_select "input[name=?]", "devolution[datetime,]"

      assert_select "input[name=?]", "devolution[finish_time_discharge]"

      assert_select "input[name=?]", "devolution[datetime,]"

      assert_select "input[name=?]", "devolution[started_user_id]"

      assert_select "input[name=?]", "devolution[integer,]"

      assert_select "input[name=?]", "devolution[charge_type_delivery]"

      assert_select "input[name=?]", "devolution[integer,]"

      assert_select "input[name=?]", "devolution[date_start_avaria]"

      assert_select "input[name=?]", "devolution[date,]"

      assert_select "input[name=?]", "devolution[date_finish_avaria]"

      assert_select "input[name=?]", "devolution[date,]"

      assert_select "input[name=?]", "devolution[time_start_avaria]"

      assert_select "input[name=?]", "devolution[time,]"

      assert_select "input[name=?]", "devolution[time_finish_avaria]"

      assert_select "input[name=?]", "devolution[time,]"

      assert_select "input[name=?]", "devolution[status]"

      assert_select "input[name=?]", "devolution[integer,]"

      assert_select "input[name=?]", "devolution[user_id]"

      assert_select "input[name=?]", "devolution[references,]"

      assert_select "input[name=?]", "devolution[received_user_id]"

      assert_select "input[name=?]", "devolution[references,]"

      assert_select "input[name=?]", "devolution[breakdown_user_id]"

      assert_select "input[name=?]", "devolution[references,]"

      assert_select "input[name=?]", "devolution[observation]"

      assert_select "input[name=?]", "devolution[text]"
    end
  end
end
