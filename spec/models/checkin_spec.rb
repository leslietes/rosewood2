describe Checkin do
  it "returns occupied room" do
    checkin = FactoryGirl.create(:checkin)
    Checkin.find_by_room(checkin.room_id).first.should eq checkin
  end
  
  it "removes checkin data on vacate room" do
    checkin = FactoryGirl.create(:checkin)
    checkin.vacate!
    Checkin.all.count.should eq 0
    CheckinDetail.all.count.should eq 0
    CheckinOccupant.all.count.should eq 0
  end
  
  it "allow occupant to transfer room" do
    checkin = FactoryGirl.create(:checkin)
    room    = FactoryGirl.create(:room)
    checkin.transfer_room(room.id)
    checkin.room_id.should eq room.id
    checkin.room_no.should eq room.room_no
  end
end