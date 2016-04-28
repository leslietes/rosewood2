describe BillingsController do
  
  it "index requires authenticated user" do
    get :index
    response.should redirect_to new_user_session_url
  end
  
  it "new requires authenticated user" do
    get :new
    response.should redirect_to new_user_session_url
  end
  
  it "show requires authenticated user" do
    billing = FactoryGirl.create(:billing)
    get :show, id: billing.id
    response.should redirect_to new_user_session_url
  end

  it "edit requires authenticated user" do
    billing = FactoryGirl.create(:billing)
    get :edit, id: billing.id
    response.should redirect_to new_user_session_url
  end
  
  it "delete requires authenticated user" do
    billing = FactoryGirl.create(:billing)
    get :destroy, id: billing.id
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
    
      it "populates an array of utilities" do
        billing = FactoryGirl.create(:billing)
        get :index
        assigns(:billings).should eq([billing])
      end
    end
    
    context "show page" do
      it "redirects to billing_details :show view" do
        @billing = FactoryGirl.create(:billing)
        get :show, id: @billing
        response.should redirect_to billing_billing_details_url(billing_id: @billing.id)
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
        @billing = FactoryGirl.create(:billing)
        get :edit, id: @billing
        response.should render_template :edit
      end
    end
    
    context "create page with valid attributes" do
      it "creates a new billing" do
        expect {
          post :create, billing: FactoryGirl.attributes_for(:billing)
        }.to change(Billing,:count).by(1)
      end
    
      it "redirects to billing_details :show page after create" do
        post :create, billing: FactoryGirl.attributes_for(:billing)
        billing = Billing.last
        response.should redirect_to billing_billing_details_url(billing_id: billing.id)
      end
    end
    
    context "update page with valid attributes" do
      before :each do
        @billing = FactoryGirl.create(:billing)
      end
      
      it "locates the requested billing" do
        put :update, id: @billing, billing: FactoryGirl.attributes_for(:billing)
        assigns(:billing).should eq(@billing)
      end
      
      it "changes billint attribute" do
        put :update, id: @billing, billing: FactoryGirl.attributes_for(:billing, room_month: "December")
        @billing.reload
        @billing.room_month.should eq("December")
      end
      
      it "redirects to updated billing" do
        put :update, id: @billing, billing: FactoryGirl.attributes_for(:billing)
        response.should redirect_to billings_url
      end
    end
  end
  
  
  context "update electricity and water reading" do
    before :each do
      @user    = FactoryGirl.create(:user)
      @room    = FactoryGirl.create(:room)
      @checkin = FactoryGirl.create(:checkin) 
      @elec    = FactoryGirl.create(:electricity)
      @water   = FactoryGirl.create(:utility)
    
      @billing = FactoryGirl.create(:billing)
      @detail  = @billing.billing_details.create(checkin_id: @checkin.id, room_no: @room.id, user_id: 1)
      @util1 = @detail.billing_utilities.create(utility_name: @elec.name,  rate: @elec.first_rate,  user_id: 1, billing_id: @billing.id)  
      @util2 = @detail.billing_utilities.create(utility_name: @water.name, rate: @water.first_rate, user_id: 1, billing_id: @billing.id)  
    end
    
    it "redirects to login page without signin" do
      get :electricity_reading, id: @billing.id
      response.should redirect_to new_user_session_url
    end
    
    it "redirects to login page without signin" do
      get :water_reading, id: @billing.id
      response.should redirect_to new_user_session_url
    end
  
    it "gets electricity reading page" do
      sign_in :user, @user

      get :electricity_reading, id: @billing.id
      response.should render_template :electricity_reading
    end
    
    it "gets water reading page" do
      sign_in :user, @user
      
      get :water_reading, id: @billing.id
      response.should render_template :water_reading
    end
    
    it "updates electricity readings" do
      sign_in :user, @user

      get  :electricity_reading, id: @billing.id
      post :electricity_reading, id: @billing.id, utilities: { "#{@util1.id}" => {from: 5, to: 10} } 
      
      expect(flash[:notice]).to eq "Electricity Reading successfully added"
      response.should redirect_to billing_billing_details_url(billing_id: @billing.id)
    end
    
    it "updates water readings" do
      sign_in :user, @user

      get  :water_reading, id: @billing.id
      post :water_reading, id: @billing.id, utilities: { "#{@util2.id}" => {from: 5, to: 10} } 
      
      expect(flash[:notice]).to eq "Water Reading successfully added"
      response.should redirect_to billing_billing_details_url(billing_id: @billing.id)
      
    end
    
  end
end