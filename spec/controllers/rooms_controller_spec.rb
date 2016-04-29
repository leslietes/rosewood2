describe RoomsController do
  
  it "index requires authenticated user" do
    get :index
    response.should redirect_to new_user_session_url
  end
  
  it "new requires authenticated user" do
    get :new
    response.should redirect_to new_user_session_url
  end
  
  it "show requires authenticated user" do
    room = FactoryGirl.create(:room)
    get :show, id: room.id
    response.should redirect_to new_user_session_url
  end

  it "edit requires authenticated user" do
    room = FactoryGirl.create(:room)
    get :edit, id: room.id
    response.should redirect_to new_user_session_url
  end
  
  it "delete requires authenticated user" do
    room = FactoryGirl.create(:room)
    get :destroy, id: room.id
    response.should redirect_to new_user_session_url
  end
  
  #it "check in requires authenticated user" do
  #  get :check_in
  #  response.should redirect_to new_user_session_url
  #end
  
  describe "sign in user" do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in :user, @user
    end
    
    context "index page" do
      it "renders the :index view" do
        get :index
        response.should render_template :index  
      end
    
      it "populates an array of rooms" do
        room = FactoryGirl.create(:room)
        get :index
        assigns(:rooms).should eq([room])
      end
    end
    
    context "show page" do
      it "renders the :show view" do
        room = FactoryGirl.create(:room)
        get :show, id: room
        response.should render_template :show
      end
    end
    
    context "new page" do
      it "renders the :new view" do
        get :new
        response.should render_template :new
      end
    end
    
    context "edit page" do
      it "renders the :edit view" do
        room = FactoryGirl.create(:room)
        get :edit, id: room.id
        response.should render_template :edit
      end
    end
    
    context "create page with valid attributes" do
      it "creates a new room" do
        expect {
          post :create, room: FactoryGirl.attributes_for(:room)
        }.to change(Room,:count).by(1)
      end
    
      it "redirects to index page after create" do
        post :create, room: FactoryGirl.attributes_for(:room)
        response.should redirect_to rooms_url
      end
    end
    
    context "create page with invalid attributes" do
      it "renders new page on create error" do
        post :create, room: FactoryGirl.attributes_for(:invalid_room)
        response.should render_template :new
      end
      
      it "does not save new room" do
        expect {
          post :create, room: FactoryGirl.attributes_for(:invalid_room)
        }.to_not change(Room,:count)
      end
    end
    
    context "update page with valid attributes" do
      before :each do
        @room = FactoryGirl.create(:room)
      end
      
      it "locates the requested room" do
        put :update, id: @room, room: FactoryGirl.attributes_for(:room)
        assigns(:room).should eq(@room)
      end
      
      it "changes room attribute" do
        put :update, id: @room, room: FactoryGirl.attributes_for(:room, room_rate: 10000)
        @room.reload
        @room.room_rate.should eq(10000)
      end
      
      it "redirects to updated room" do
        put :update, id: @room, room: FactoryGirl.attributes_for(:room)
        response.should redirect_to rooms_url
      end
    end
    
    context "update page with invalid attributes" do
      before :each do
        @room = FactoryGirl.create(:room)
      end
      
      it "locates the requested room" do
        put :update, id: @room, room: FactoryGirl.attributes_for(:invalid_room)
        assigns(:room).should eq(@room)
      end
      
      it "does not change room's attributes" do
        put :update, id: @room, room: FactoryGirl.attributes_for(:invalid_room)
        @room.reload
        @room.room_rate.should_not eq nil
        @room.max_occupants.should_not eq nil
      end
      
      it "renders the edit page" do
        put :update, id: @room, room: FactoryGirl.attributes_for(:invalid_room)
        response.should render_template :edit
      end
    end
    
    context "destroy page" do
      before :each do
        @room = FactoryGirl.create(:room)  
      end
      
      it "deletes the room" do
        expect{
          delete :destroy, id: @room
        }.to change(Room,:count).by(-1)
      end
      
      it "redirects to index page" do
        delete :destroy, id: @room
        response.should redirect_to rooms_url
      end
    end
    
    #context "check in" do
      #before :each do
      #  @room     = FactoryGirl.create(:room)
      #  @occupant = FactoryGirl.create(:occupant)
      #  @utility  = FactoryGirl.create(:utility)
      #end
      
      #it "renders the check in page" do
      #  get :check_in
      #  response.should render_template :check_in
      #end

      #it "displays a warning if no room or no occupant selected" do
      #  get :check_in
      #  post :check_in
      #  expect(response).to render_template :check_in
      #  expect(flash[:notice]).to eq "Please select room and occupant"
      #end
      
      #it "processes a check in" do
      #  expect {
      #    post :check_in, room_no: @room.id, occupants: [@occupant.id], start_date: Date.today, user_id: 1
      #    expect(flash[:notice]).to eq "Occupant has checked in"  
      #  }.to change(Checkin,:count).by(1)
      #end
      
      #it "adds occupants" do
      #  expect {
      #    post :check_in, room_no: @room.id, occupants: [@occupant.id], start_date: Date.today, user_id: 1
      #    expect(flash[:notice]).to eq "Occupant has checked in"  
      #  }.to change(CheckinOccupant,:count).by(1)
      #end
    
      #it "adds utilities" do
      #  expect {
      #    post :check_in, room_no: @room.id, occupants: [@occupant.id], start_date: Date.today, utilities: ["#{@utility.id}"], user_id: 1
      #    expect(flash[:notice]).to eq "Occupant has checked in"  
      #  }.to change(CheckinDetail,:count).by(1)
      #end
      
      #it "displays an error if room not found" do
      #  post :check_in, room_no: 1, occupants: [@occupant.id], start_date: Date.today, user_id: 1
      #  expect(flash[:error]).to eq "Unable to check in. Please select valid room or occupant"  
      #end
      
      #end
    
    #context "occupancy list" do
      #before :each do
      #  @room     = FactoryGirl.create(:room)
      #  @occupant = FactoryGirl.create(:occupant)
      #  @utility  = FactoryGirl.create(:utility)
      #end
      
      #it "renders occupancy list page" do
      #  get :occupancy_list
      #  response.should render_template :occupancy_list
      #end
      
      #it "renders occupancy details page" do
      #  checkin = Checkin.create(room_id: @room.id, room_no: @room.room_no, start_date: Date.today, user_id: 1)
      #  details = checkin.checkin_details.create(utility_id: @utility.id, start_date: Date.today, amount: @utility.first_rate, user_id: 1)
      #  checkin.checkin_occupants.create(occupant_id: @occupant.id, start_date: Date.today, user_id: 1)
        
      #  get :occupancy_details, id: checkin.id
      #  response.should render_template :occupancy_details
      #end
      #end
    
    #context "checkin actions" do
      #before :each do
      #  @room     = FactoryGirl.create(:room)
      #  @room1    = FactoryGirl.create(:room1)
      #  @occupant = FactoryGirl.create(:occupant)
      #  @occupant1= FactoryGirl.create(:occupant1)
      #  @utility  = FactoryGirl.create(:utility)
      #  @utility1 = FactoryGirl.create(:electricity)
        
      #  @checkin = Checkin.create(room_id: @room.id, room_no: @room.room_no, start_date: Date.today, user_id: 1)
      #  @details = @checkin.checkin_details.create(utility_id: @utility.id, start_date: Date.today, amount: @utility.first_rate, user_id: 1)
      #  @checkin.checkin_occupants.create(occupant_id: @occupant.id, start_date: Date.today, user_id: 1)
      #end
      
      #it "adds new occupant error when no occupant or utilities selected" do
      #  get :occupancy_details, id: @checkin.id
      #  post :new_roommate, id: @checkin.id
        
      #  expect(flash[:notice]).to eq "Please select new roommate or utility to add"
      #end
      
      #it "adds new occupant when an occupant is selected" do
      #  get :occupancy_details, id: @checkin.id
      #  post :new_roommate, id: @checkin.id, occupants: [@occupant1.id]
        
      #  expect(flash[:notice]).to eq "New roommate or utility added"
      #  response.should redirect_to occupancy_details_room_url        
      #end
      
      #it "adds new utility when a utility selected" do
      #  get :occupancy_details, id: @checkin.id
      #  post :new_roommate, id: @checkin.id, utilities: [@utility1.id]
        
      #  expect(flash[:notice]).to eq "New roommate or utility added"
      #  response.should redirect_to occupancy_details_room_url        
      #end
      
      #it "removes occupant" do
      #  get :remove_occupant, id: @checkin.checkin_occupants.first.id
      #  expect(flash[:notice]).to eq "Occupant has vacated room"
      #  response.should redirect_to occupancy_details_room_url(id: @checkin.id)
      #end
      
      #it "removes utilitiy" do
      #  get :remove_utility, id: @checkin.checkin_details.first.id
      #  expect(flash[:notice]).to eq "Utility was removed from room"
      #  response.should redirect_to occupancy_details_room_url(id: @checkin.id)
      #end
      
      #it "vacates room" do
      #  get :vacate, id: @checkin.id
      #  expect(flash[:notice]).to eq "Room has been vacated"
      #  response.should redirect_to occupancy_list_rooms_url  
      #end
      
      #it "transfers occupants to another room" do
      #  get :transfer, id: @checkin.id, new_room_id: @room1.id, room_id: @room.id
      #  expect(flash[:notice]).to eq "Room transfer was made successfully"
      #  response.should redirect_to occupancy_details_room_url(id: @checkin.id)
      #end
      #end
    
  end    
end