describe BillingDetail do
  it "adds billing utility" do
    user    = FactoryGirl.create(:user)
    room    = FactoryGirl.create(:room)
    billing = FactoryGirl.create(:billing)
    utility = FactoryGirl.create(:utility)
    checkin = FactoryGirl.create(:checkin)
    
    detail = billing.billing_details.create(user_id: user.id, room_no: room.room_no, checkin_id: checkin.id)
    expect detail.billing_utilities.count.should eq 0
    
    detail.add_billing_utility(utility.id, user.id)
    expect detail.billing_utilities.count.should eq 1
  end
end