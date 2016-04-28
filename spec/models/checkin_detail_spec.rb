describe CheckinDetail do
  it "deletes row data" do
    utility = FactoryGirl.create(:utility)
    checkin = FactoryGirl.create(:checkin)
    checkin.checkin_details.create(utility_id: utility.id, amount: 400, start_date: Date.today, user_id: 1)
    
    checkin.checkin_details.count.should eq 1
    checkin.checkin_details.first.remove!
    checkin.checkin_details.count.should eq 0
  end
end