describe CheckinsController do
  
  it "index requires authenticated user" do
    get :index
    response.should redirect_to new_user_session_url
  end
  
  it "new requires authenticated user" do
    get :new
    response.should redirect_to new_user_session_url
  end
  
  it "show requires authenticated user" do
    checkin = FactoryGirl.create(:checkin)
    get :show, id: checkin.id
    response.should redirect_to new_user_session_url
  end
  
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
        room    = FactoryGirl.create(:room)
        occupant= FactoryGirl.create(:occupant)
        
        checkin = Checkin.create(room_id: room.id, room_no: room.room_no, start_date: Date.today, user_id: 1)
        checkin.checkin_occupants.create(occupant_id: occupant.id, start_date: Date.today, user_id: 1)
        
        get :show, id: checkin.id
        response.should render_template :show
      end
    end
    
    context "new page" do
      it "renders the :new view" do
        get :new
        response.should render_template :new
      end
    end
    
    context "create or check in" do
      before :each do
        @room     = FactoryGirl.create(:room)
        @occupant = FactoryGirl.create(:occupant)
        @utility  = FactoryGirl.create(:utility)
      end
      
      it "displays a warning if no room or no occupant selected" do
        post :create, start_date: Date.today, user_id: 1
        expect(response).to render_template :new
        expect(flash[:notice]).to eq "Please select room and occupant"
      end
      
      it "processes a check in" do
        expect {
          post :create, room_no: @room.id, occupants: [@occupant.id], start_date: Date.today, user_id: 1
          expect(flash[:notice]).to eq "Occupant has checked in"  
        }.to change(Checkin,:count).by(1)
      end
      
      it "adds occupants" do
        expect {
          post :create, room_no: @room.id, occupants: [@occupant.id], start_date: Date.today, user_id: 1
          expect(flash[:notice]).to eq "Occupant has checked in"  
        }.to change(CheckinOccupant,:count).by(1)
      end
    
      it "adds utilities" do
        expect {
          post :create, room_no: @room.id, occupants: [@occupant.id], start_date: Date.today, utilities: ["#{@utility.id}"], user_id: 1
          expect(flash[:notice]).to eq "Occupant has checked in"  
        }.to change(CheckinDetail,:count).by(1)
      end
      
      it "displays an error if room not found" do
        post :create, room_no: 1, occupants: [@occupant.id], start_date: Date.today, user_id: 1
        expect(flash[:notice]).to eq "Unable to check in. Please select valid room or occupant"  
      end  
    end
    
    context "index method or checkin list" do
      before :each do
        @room     = FactoryGirl.create(:room)
        @occupant = FactoryGirl.create(:occupant)
        @utility  = FactoryGirl.create(:utility)
      end
      
      it "renders index or checkin list page" do
        get :index
        response.should render_template :index
      end
      
      it "renders show or checkin details page" do
        checkin = Checkin.create(room_id: @room.id, room_no: @room.room_no, start_date: Date.today, user_id: 1)
        details = checkin.checkin_details.create(utility_id: @utility.id, start_date: Date.today, amount: @utility.first_rate, user_id: 1)
        checkin.checkin_occupants.create(occupant_id: @occupant.id, start_date: Date.today, user_id: 1)
        
        get :show, id: checkin.id
        response.should render_template :show
      end
    end
    
    context "checkin actions" do
      before :each do
        @room     = FactoryGirl.create(:room)
        @room1    = FactoryGirl.create(:room1)
        @occupant = FactoryGirl.create(:occupant)
        @occupant1= FactoryGirl.create(:occupant1)
        @utility  = FactoryGirl.create(:utility)
        @utility1 = FactoryGirl.create(:electricity)
        
        @checkin = Checkin.create(room_id: @room.id, room_no: @room.room_no, start_date: Date.today, user_id: 1)
        @details = @checkin.checkin_details.create(utility_id: @utility.id, start_date: Date.today, amount: @utility.first_rate, user_id: 1)
        @checkin.checkin_occupants.create(occupant_id: @occupant.id, start_date: Date.today, user_id: 1)
      end
      
      it "adds new occupant error when no occupant or utilities selected" do
        get :show, id: @checkin.id
        post :new_roommate, id: @checkin.id
        
        expect(flash[:notice]).to eq "Please select new roommate or utility to add"
      end
      
      it "adds new occupant when an occupant is selected" do
        get :show, id: @checkin.id
        post :new_roommate, id: @checkin.id, occupants: [@occupant1.id]
        
        expect(flash[:notice]).to eq "New roommate or utility added"
        response.should redirect_to checkin_url(@checkin.id)        
      end
      
      it "adds new utility when a utility selected" do
        get :show, id: @checkin.id
        post :new_roommate, id: @checkin.id, utilities: [@utility1.id]
        
        expect(flash[:notice]).to eq "New roommate or utility added"
        response.should redirect_to checkin_url(@checkin.id)        
      end
      
      it "removes occupant" do
        get :remove_occupant, id: @checkin.checkin_occupants.first.id
        expect(flash[:notice]).to eq "Occupant has vacated room"
        response.should redirect_to checkin_url(@checkin.id)
      end
      
      it "removes utilitiy" do
        get :remove_utility, id: @checkin.checkin_details.first.id
        expect(flash[:notice]).to eq "Utility was removed from room"
        response.should redirect_to checkin_url(@checkin.id)
      end
      
      it "vacates room" do
        get :vacate, id: @checkin.id
        expect(flash[:notice]).to eq "Room has been vacated"
        response.should redirect_to checkins_url  
      end
      
      it "transfers occupants to another room" do
        get :transfer, id: @checkin.id, new_room_id: @room1.id, room_id: @room.id
        expect(flash[:notice]).to eq "Room transfer was made successfully"
        response.should redirect_to checkin_url(@checkin.id)
      end
    end
    
  end    
  
end