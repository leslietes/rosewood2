describe BillingDetailsController do
  
  context "require sign in user" do
    before :each do
      @room    = FactoryGirl.create(:room)
      @checkin = FactoryGirl.create(:checkin)
      @billing = FactoryGirl.create(:billing)
    
      @detail  = @billing.billing_details.create(checkin_id: @checkin.id, room_no: @room.id, user_id: 1)  
    end
    
    it "index requires authenticated user" do
      get :index, billing_id: @billing.id
      response.should redirect_to new_user_session_url
    end
  
    it "show requires authenticated user" do
      get :show, billing_id: @billing.id, id: @detail.id 
      response.should redirect_to new_user_session_url
    end
    
    it "edit requires authenticated user" do
      get :edit, billing_id: @billing.id, id: @detail.id
      response.should redirect_to new_user_session_url
    end

    it "delete requires authenticated user" do
      get :destroy, billing_id: @billing.id, id: @detail.id
      response.should redirect_to new_user_session_url
    end 
  end
  
  describe "sign in user" do
    before :each do
      @user = FactoryGirl.create(:user)
      sign_in :user, @user  
      
      @room    = FactoryGirl.create(:room)
      @checkin = FactoryGirl.create(:checkin)
      @billing = FactoryGirl.create(:billing)
    
      @detail  = @billing.billing_details.create(checkin_id: @checkin.id, room_no: @room.id, user_id: @user.id)
    end
    
    context "index page" do
      it "renders the :index view" do
        get :index, billing_id: @billing.id
        response.should render_template :index  
      end
    
      it "populates billing" do
        get :index, billing_id: @billing.id
        assigns(:billing).should eq @billing
      end
    end
    
    context "show page" do
      it "renders the :show view" do
        get :show, billing_id: @billing.id, id: @detail.id
        response.should render_template :show
      end
    end
    
    context "edit page" do
      it "renders the :edit page" do
        get :edit, billing_id: @billing.id, id: @detail.id
        response.should render_template :edit
      end
    end
    
    context "add utilities" do
      it "redirects if no utility selected" do
        utility = FactoryGirl.create(:utility)
      
        post :add_billing_utilities, billing_id: @billing.id, id: @detail.id, user_id: 1  
        expect(flash[:notice]).to eq "Please select extras to add"
        response.should redirect_to edit_billing_billing_detail_url(billing_id: @billing.id, id: @detail.id)
      end
      
      it "adds utilities" do
        utility = FactoryGirl.create(:utility)
      
        post :add_billing_utilities, billing_id: @billing.id, id: @detail.id, new_billing_utility: utility.id, user_id: 1  
        expect(flash[:notice]).to eq "Additional billing charges added successfully"
        response.should redirect_to edit_billing_billing_detail_url(billing_id: @billing.id, id: @detail.id)
      end
    end  
    
    context "remove_utilities" do
      it "removes billing charges" do
        utility = FactoryGirl.create(:utility)
        billing_utility = @detail.billing_utilities.create(billing_id: @billing.id, utility_name: utility.name, rate: utility.first_limit, user_id: @user.id)
        
        delete :remove_billing_utilities, billing_id: @billing.id, billing_details_id: @detail.id, id: billing_utility.id
        
        expect(flash[:notice]).to eq "Billing Utility was successfully destroyed."
        response.should redirect_to edit_billing_billing_detail_url(billing_id: @billing.id, id: @detail.id)
      end
    end  
  end
end