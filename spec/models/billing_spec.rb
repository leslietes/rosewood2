describe Billing do
  it "returns room period" do
    billing = FactoryGirl.create(:billing)
    expect billing.room_period.should eq "January 2016"
  end
  
  it "returns utilities period" do
    billing = FactoryGirl.create(:billing)
    expect billing.utilities_period.should eq "February 2016"
  end
  
  it "generates billing details" do
    billing = FactoryGirl.create(:billing)
    room    = FactoryGirl.create(:room_rate)
    water   = FactoryGirl.create(:utility)
    
    checkin = FactoryGirl.create(:checkin)
    checkin.checkin_occupants.create(occupant_id: 1, start_date: Date.today, user_id: 1)
    checkin.checkin_details.create(utility_id: room.id,  amount: 10000, user_id: 1)
    checkin.checkin_details.create(utility_id: water.id, amount: 1000,  user_id: 1)

    billing.generate_billing_details(1)
    
    expect billing.billing_details.count.should eq(1)
    expect billing.billing_details.first.billing_utilities.count.should eq(2)
  end
  
  it "returns billing details" do
    billing = FactoryGirl.create(:billing)
    room    = FactoryGirl.create(:room_rate)
    water   = FactoryGirl.create(:utility)
    
    checkin = FactoryGirl.create(:checkin)
    checkin.checkin_occupants.create(occupant_id: 1, start_date: Date.today, user_id: 1)
    checkin.checkin_details.create(utility_id: room.id,  amount: 10000, user_id: 1)
    checkin.checkin_details.create(utility_id: water.id, amount: 1000,  user_id: 1)
    
    billing.generate_billing_details(1)
    
    expect Billing.get_details(billing.id).should eq(1)
  end
end