require 'rails_helper'

RSpec.describe "devolutions/index", type: :view do
  before(:each) do
    assign(:devolutions, [
      Devolution.create!(
        :carrier_id => "Carrier",
        :references, => "References,",
        :driver_id => "Driver",
        :references, => "References,",
        :billing_client_id => "Billing Client",
        :references, => "References,",
        :place => "Place",
        :string, => "String,",
        :place_horse => "Place Horse",
        :string, => "String,",
        :place_cart_1 => "Place Cart 1",
        :string, => "String,",
        :date_entry => "Date Entry",
        :date, => "Date,",
        :time_entry => "Time Entry",
        :time, => "Time,",
        :date_receipt => "Date Receipt",
        :date, => "Date,",
        :date_closing => "Date Closing",
        :date, => "Date,",
        :date_scheduled => "Date Scheduled",
        :date, => "Date,",
        :time_scheduled => "Time Scheduled",
        :time, => "Time,",
        :motive_scheduled => "Motive Scheduled",
        :text, => "Text,",
        :palletized => "Palletized",
        :boolean, => "Boolean,",
        :quantity_pallets => "Quantity Pallets",
        :integer, => "Integer,",
        :weight => "Weight",
        :decimal, => "Decimal,",
        :volume => "Volume",
        :decimal, => "Decimal,",
        :value_ton => "Value Ton",
        :decimal, => "Decimal,",
        :value_kg => "Value Kg",
        :decimal, => "Decimal,",
        :value_total => "Value Total",
        :decimal, => "Decimal,",
        :charge_discharge => "Charge Discharge",
        :boolean, => "Boolean,",
        :shipment => "Shipment",
        :string, => "String,",
        :team => "Team",
        :integer, => "Integer,",
        :dock => "Dock",
        :integer, => "Integer,",
        :hangar => "",
        :container => "Container",
        :string, => "String,",
        :place_confirmed => "Place Confirmed",
        :string, => "String,",
        :start_time_discharge => "Start Time Discharge",
        :datetime, => "Datetime,",
        :finish_time_discharge => "Finish Time Discharge",
        :datetime, => "Datetime,",
        :started_user_id => "Started User",
        :integer, => "Integer,",
        :charge_type_delivery => "Charge Type Delivery",
        :integer, => "Integer,",
        :date_start_avaria => "Date Start Avaria",
        :date, => "Date,",
        :date_finish_avaria => "Date Finish Avaria",
        :date, => "Date,",
        :time_start_avaria => "Time Start Avaria",
        :time, => "Time,",
        :time_finish_avaria => "Time Finish Avaria",
        :time, => "Time,",
        :status => "Status",
        :integer, => "Integer,",
        :user_id => "User",
        :references, => "References,",
        :received_user_id => "Received User",
        :references, => "References,",
        :breakdown_user_id => "Breakdown User",
        :references, => "References,",
        :observation => "Observation",
        :text => "Text"
      ),
      Devolution.create!(
        :carrier_id => "Carrier",
        :references, => "References,",
        :driver_id => "Driver",
        :references, => "References,",
        :billing_client_id => "Billing Client",
        :references, => "References,",
        :place => "Place",
        :string, => "String,",
        :place_horse => "Place Horse",
        :string, => "String,",
        :place_cart_1 => "Place Cart 1",
        :string, => "String,",
        :date_entry => "Date Entry",
        :date, => "Date,",
        :time_entry => "Time Entry",
        :time, => "Time,",
        :date_receipt => "Date Receipt",
        :date, => "Date,",
        :date_closing => "Date Closing",
        :date, => "Date,",
        :date_scheduled => "Date Scheduled",
        :date, => "Date,",
        :time_scheduled => "Time Scheduled",
        :time, => "Time,",
        :motive_scheduled => "Motive Scheduled",
        :text, => "Text,",
        :palletized => "Palletized",
        :boolean, => "Boolean,",
        :quantity_pallets => "Quantity Pallets",
        :integer, => "Integer,",
        :weight => "Weight",
        :decimal, => "Decimal,",
        :volume => "Volume",
        :decimal, => "Decimal,",
        :value_ton => "Value Ton",
        :decimal, => "Decimal,",
        :value_kg => "Value Kg",
        :decimal, => "Decimal,",
        :value_total => "Value Total",
        :decimal, => "Decimal,",
        :charge_discharge => "Charge Discharge",
        :boolean, => "Boolean,",
        :shipment => "Shipment",
        :string, => "String,",
        :team => "Team",
        :integer, => "Integer,",
        :dock => "Dock",
        :integer, => "Integer,",
        :hangar => "",
        :container => "Container",
        :string, => "String,",
        :place_confirmed => "Place Confirmed",
        :string, => "String,",
        :start_time_discharge => "Start Time Discharge",
        :datetime, => "Datetime,",
        :finish_time_discharge => "Finish Time Discharge",
        :datetime, => "Datetime,",
        :started_user_id => "Started User",
        :integer, => "Integer,",
        :charge_type_delivery => "Charge Type Delivery",
        :integer, => "Integer,",
        :date_start_avaria => "Date Start Avaria",
        :date, => "Date,",
        :date_finish_avaria => "Date Finish Avaria",
        :date, => "Date,",
        :time_start_avaria => "Time Start Avaria",
        :time, => "Time,",
        :time_finish_avaria => "Time Finish Avaria",
        :time, => "Time,",
        :status => "Status",
        :integer, => "Integer,",
        :user_id => "User",
        :references, => "References,",
        :received_user_id => "Received User",
        :references, => "References,",
        :breakdown_user_id => "Breakdown User",
        :references, => "References,",
        :observation => "Observation",
        :text => "Text"
      )
    ])
  end

  it "renders a list of devolutions" do
    render
    assert_select "tr>td", :text => "Carrier".to_s, :count => 2
    assert_select "tr>td", :text => "References,".to_s, :count => 2
    assert_select "tr>td", :text => "Driver".to_s, :count => 2
    assert_select "tr>td", :text => "References,".to_s, :count => 2
    assert_select "tr>td", :text => "Billing Client".to_s, :count => 2
    assert_select "tr>td", :text => "References,".to_s, :count => 2
    assert_select "tr>td", :text => "Place".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Place Horse".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Place Cart 1".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Date Entry".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Time Entry".to_s, :count => 2
    assert_select "tr>td", :text => "Time,".to_s, :count => 2
    assert_select "tr>td", :text => "Date Receipt".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Date Closing".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Date Scheduled".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Time Scheduled".to_s, :count => 2
    assert_select "tr>td", :text => "Time,".to_s, :count => 2
    assert_select "tr>td", :text => "Motive Scheduled".to_s, :count => 2
    assert_select "tr>td", :text => "Text,".to_s, :count => 2
    assert_select "tr>td", :text => "Palletized".to_s, :count => 2
    assert_select "tr>td", :text => "Boolean,".to_s, :count => 2
    assert_select "tr>td", :text => "Quantity Pallets".to_s, :count => 2
    assert_select "tr>td", :text => "Integer,".to_s, :count => 2
    assert_select "tr>td", :text => "Weight".to_s, :count => 2
    assert_select "tr>td", :text => "Decimal,".to_s, :count => 2
    assert_select "tr>td", :text => "Volume".to_s, :count => 2
    assert_select "tr>td", :text => "Decimal,".to_s, :count => 2
    assert_select "tr>td", :text => "Value Ton".to_s, :count => 2
    assert_select "tr>td", :text => "Decimal,".to_s, :count => 2
    assert_select "tr>td", :text => "Value Kg".to_s, :count => 2
    assert_select "tr>td", :text => "Decimal,".to_s, :count => 2
    assert_select "tr>td", :text => "Value Total".to_s, :count => 2
    assert_select "tr>td", :text => "Decimal,".to_s, :count => 2
    assert_select "tr>td", :text => "Charge Discharge".to_s, :count => 2
    assert_select "tr>td", :text => "Boolean,".to_s, :count => 2
    assert_select "tr>td", :text => "Shipment".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Team".to_s, :count => 2
    assert_select "tr>td", :text => "Integer,".to_s, :count => 2
    assert_select "tr>td", :text => "Dock".to_s, :count => 2
    assert_select "tr>td", :text => "Integer,".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
    assert_select "tr>td", :text => "Container".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Place Confirmed".to_s, :count => 2
    assert_select "tr>td", :text => "String,".to_s, :count => 2
    assert_select "tr>td", :text => "Start Time Discharge".to_s, :count => 2
    assert_select "tr>td", :text => "Datetime,".to_s, :count => 2
    assert_select "tr>td", :text => "Finish Time Discharge".to_s, :count => 2
    assert_select "tr>td", :text => "Datetime,".to_s, :count => 2
    assert_select "tr>td", :text => "Started User".to_s, :count => 2
    assert_select "tr>td", :text => "Integer,".to_s, :count => 2
    assert_select "tr>td", :text => "Charge Type Delivery".to_s, :count => 2
    assert_select "tr>td", :text => "Integer,".to_s, :count => 2
    assert_select "tr>td", :text => "Date Start Avaria".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Date Finish Avaria".to_s, :count => 2
    assert_select "tr>td", :text => "Date,".to_s, :count => 2
    assert_select "tr>td", :text => "Time Start Avaria".to_s, :count => 2
    assert_select "tr>td", :text => "Time,".to_s, :count => 2
    assert_select "tr>td", :text => "Time Finish Avaria".to_s, :count => 2
    assert_select "tr>td", :text => "Time,".to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "Integer,".to_s, :count => 2
    assert_select "tr>td", :text => "User".to_s, :count => 2
    assert_select "tr>td", :text => "References,".to_s, :count => 2
    assert_select "tr>td", :text => "Received User".to_s, :count => 2
    assert_select "tr>td", :text => "References,".to_s, :count => 2
    assert_select "tr>td", :text => "Breakdown User".to_s, :count => 2
    assert_select "tr>td", :text => "References,".to_s, :count => 2
    assert_select "tr>td", :text => "Observation".to_s, :count => 2
    assert_select "tr>td", :text => "Text".to_s, :count => 2
  end
end
