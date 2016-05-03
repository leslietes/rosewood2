describe Room do
  
  it "has a valid factory" do
    room = FactoryGirl.create(:room)
    expect(room).to be_valid  
  end
  
  it "is invalid without a room number" do
    room = FactoryGirl.build(:room, room_no: nil)
    expect(room).to be_invalid
  end
  
  it "is invalid without max occupants" do
    room = FactoryGirl.build(:room, max_occupants: nil)
    expect(room).to be_invalid
  end
  
  it "is invalid without room rate" do
    room = FactoryGirl.build(:room, room_rate: nil)
    expect(room).to be_invalid
  end
  
  it "returns vacant rooms" do
    FactoryGirl.create(:room)
    FactoryGirl.create(:room1)
    Room.all_vacant.count.should be 2
  end
  
  it "returns unoccupied rooms" do
    FactoryGirl.create(:room)
    Room.unoccupied.size.should be 1
  end
  
  it "sets status to occupied" do
    room = FactoryGirl.create(:room)
    Room.occupied!(room.id)
    Room.unoccupied.size.should be 0  
  end
  
  it "sets status to vacated" do
    room = FactoryGirl.create(:room)
    Room.occupied!(room.id)
    Room.vacated!(room.id)
    Room.all_vacant.size.should be 1
  end
  
  it "returns room no" do
    room = FactoryGirl.create(:room)
    Room.room_no(room.id).should be 101
  end
  
  it "returns room rate" do
    room = FactoryGirl.create(:room)
    
    rate = Room.room_rate(room.id)
    expect rate == room.room_rate
  end

  describe "room checkins create room data" do
    before :each do
      @room = FactoryGirl.create(:room)
      @user = FactoryGirl.create(:user)
    end
    
    it "returns start date if has checkin" do
      @room.checkins.create(room_id: @room.id, start_date: Date.today, user_id: @user.id, room_no: @room.room_no, user_id: 1)
      @room.reload
      @room.start_date.should eq Date.today.to_s
    end
  
    it "returns nil if no checkins" do
      @room.reload
      @room.start_date.should eq ""
    end
  
    it "returns true if room has checkins" do
      @room.checkins.create(room_id: @room.id, start_date: Date.today, user_id: @user.id, room_no: @room.room_no, user_id: 1)
      @room.reload
      @room.has_checkin?.should eq true  
    end
  
    it "returns false if room has no checkins" do
      @room.has_checkin?.should eq false
    end
  end
  
  describe "occupancy_list" do
    before :each do
      @user = FactoryGirl.create(:user)
      @room = FactoryGirl.create(:room)
      @occupant= FactoryGirl.create(:occupant)      
    end
    
    it "returns occupancy list with occupant" do
      checkin  = @room.checkins.create(room_id: @room.id, start_date: Date.today, user_id: @user.id, room_no: @room.room_no)  
      occupants= checkin.checkin_occupants.create(occupant_id: @occupant.id, user_id: @user.id)
    
      list = Room.occupancy_list
      list.size.should be 1
    end
  
    it "returns VACANT if room has no checkin" do
      list = Room.occupancy_list
      list.size.should be 1
    end
  end
end