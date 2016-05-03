describe CheckinOccupant do
  it "vacates occupant from room" do
    checkin = FactoryGirl.create(:checkin)
    occupant1 = checkin.checkin_occupants.create(occupant_id: 1, start_date: Date.today, user_id: 1)
    occupant2 = checkin.checkin_occupants.create(occupant_id: 2, start_date: Date.today, user_id: 1)
    
    checkin.checkin_occupants.count.should eq 2
    
    occupant1.vacate_room!
    occupant1.end_date.should eq Date.today.to_s
  end
end