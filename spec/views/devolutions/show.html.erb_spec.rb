require 'rails_helper'

RSpec.describe "devolutions/show", type: :view do
  before(:each) do
    @devolution = assign(:devolution, Devolution.create!(
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
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Carrier/)
    expect(rendered).to match(/References,/)
    expect(rendered).to match(/Driver/)
    expect(rendered).to match(/References,/)
    expect(rendered).to match(/Billing Client/)
    expect(rendered).to match(/References,/)
    expect(rendered).to match(/Place/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Place Horse/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Place Cart 1/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Date Entry/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Time Entry/)
    expect(rendered).to match(/Time,/)
    expect(rendered).to match(/Date Receipt/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Date Closing/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Date Scheduled/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Time Scheduled/)
    expect(rendered).to match(/Time,/)
    expect(rendered).to match(/Motive Scheduled/)
    expect(rendered).to match(/Text,/)
    expect(rendered).to match(/Palletized/)
    expect(rendered).to match(/Boolean,/)
    expect(rendered).to match(/Quantity Pallets/)
    expect(rendered).to match(/Integer,/)
    expect(rendered).to match(/Weight/)
    expect(rendered).to match(/Decimal,/)
    expect(rendered).to match(/Volume/)
    expect(rendered).to match(/Decimal,/)
    expect(rendered).to match(/Value Ton/)
    expect(rendered).to match(/Decimal,/)
    expect(rendered).to match(/Value Kg/)
    expect(rendered).to match(/Decimal,/)
    expect(rendered).to match(/Value Total/)
    expect(rendered).to match(/Decimal,/)
    expect(rendered).to match(/Charge Discharge/)
    expect(rendered).to match(/Boolean,/)
    expect(rendered).to match(/Shipment/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Team/)
    expect(rendered).to match(/Integer,/)
    expect(rendered).to match(/Dock/)
    expect(rendered).to match(/Integer,/)
    expect(rendered).to match(//)
    expect(rendered).to match(/Container/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Place Confirmed/)
    expect(rendered).to match(/String,/)
    expect(rendered).to match(/Start Time Discharge/)
    expect(rendered).to match(/Datetime,/)
    expect(rendered).to match(/Finish Time Discharge/)
    expect(rendered).to match(/Datetime,/)
    expect(rendered).to match(/Started User/)
    expect(rendered).to match(/Integer,/)
    expect(rendered).to match(/Charge Type Delivery/)
    expect(rendered).to match(/Integer,/)
    expect(rendered).to match(/Date Start Avaria/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Date Finish Avaria/)
    expect(rendered).to match(/Date,/)
    expect(rendered).to match(/Time Start Avaria/)
    expect(rendered).to match(/Time,/)
    expect(rendered).to match(/Time Finish Avaria/)
    expect(rendered).to match(/Time,/)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(/Integer,/)
    expect(rendered).to match(/User/)
    expect(rendered).to match(/References,/)
    expect(rendered).to match(/Received User/)
    expect(rendered).to match(/References,/)
    expect(rendered).to match(/Breakdown User/)
    expect(rendered).to match(/References,/)
    expect(rendered).to match(/Observation/)
    expect(rendered).to match(/Text/)
  end
end
