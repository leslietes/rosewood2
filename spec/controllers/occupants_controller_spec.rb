describe OccupantsController do
  
  it "index requires authenticated user" do
    get :index
    response.should redirect_to new_user_session_url
  end
  
  it "new requires authenticated user" do
    get :new
    response.should redirect_to new_user_session_url
  end
  
  it "show requires authenticated user" do
    occupant = FactoryGirl.create(:occupant1)
    get :show, id: occupant.id
    response.should redirect_to new_user_session_url
  end

  it "edit requires authenticated user" do
    occupant = FactoryGirl.create(:occupant1)
    get :edit, id: occupant.id
    response.should redirect_to new_user_session_url
  end
  
  it "delete requires authenticated user" do
    occupant = FactoryGirl.create(:occupant1)
    get :destroy, id: occupant.id
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
    
      it "populates an array of occupants" do
        occupant = FactoryGirl.create(:occupant1)
        get :index
        assigns(:occupants).should eq([occupant])
      end
    end
    
    context "show page" do
      it "renders the :show view" do
        @occupant = FactoryGirl.create(:occupant1)
        get :show, id: @occupant
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
        @occupant = FactoryGirl.create(:occupant1)
        get :edit, id: @occupant
        response.should render_template :edit
      end
    end
    
    context "create page with valid attributes" do
      it "creates a new occupant" do
        expect {
          post :create, occupant: FactoryGirl.attributes_for(:occupant1)
        }.to change(Occupant,:count).by(1)
      end
    
      it "redirects to index page after create" do
        post :create, occupant: FactoryGirl.attributes_for(:occupant1)
        response.should redirect_to Occupant.last
      end
    end
    
    context "create page with invalid attributes" do
      it "renders new page on create error" do
        post :create, occupant: FactoryGirl.attributes_for(:invalid_occupant)
        response.should render_template :new
      end
      
      it "does not save new occupant" do
        expect {
          post :create, occupant: FactoryGirl.attributes_for(:invalid_occupant)
        }.to_not change(Occupant,:count)
      end
    end
    
    context "update page with valid attributes" do
      before :each do
        @occupant = FactoryGirl.create(:occupant)
      end
      
      it "locates the requested occupant" do
        put :update, id: @occupant, occupant: FactoryGirl.attributes_for(:occupant1)
        assigns(:occupant).should eq(@occupant)
      end
      
      it "changes occupant attribute" do
        put :update, id: @occupant, occupant: FactoryGirl.attributes_for(:occupant, first_name: "John", last_name: "Doe")
        @occupant.reload
        @occupant.first_name.should eq("John")
        @occupant.last_name.should eq("Doe")
      end
      
      it "redirects to updated occupant" do
        put :update, id: @occupant, occupant: FactoryGirl.attributes_for(:occupant1)
        response.should redirect_to @occupant
      end
    end
    
    context "update page with invalid attributes" do
      before :each do
        @occupant = FactoryGirl.create(:occupant1)
      end
      
      it "locates the requested occupant" do
        put :update, id: @occupant, occupant: FactoryGirl.attributes_for(:invalid_occupant)
        assigns(:occupant).should eq(@occupant)
      end
      
      it "does not change occupant's attributes" do
        put :update, id: @occupant, occupant: FactoryGirl.attributes_for(:invalid_occupant)
        @occupant.reload
        @occupant.first_name.should_not eq("")
        @occupant.last_name.should_not eq("")
      end
      
      it "renders the edit page" do
        put :update, id: @occupant, occupant: FactoryGirl.attributes_for(:invalid_occupant)
        response.should render_template :edit
      end
    end
    
    context "destroy page" do
      before :each do
        @occupant = FactoryGirl.create(:occupant1)  
      end
      
      it "deletes the occupant" do
        expect{
          delete :destroy, id: @occupant
        }.to change(Occupant,:count).by(-1)
      end
      
      it "redirects to index page" do
        delete :destroy, id: @occupant
        response.should redirect_to occupants_url
      end
    end
    
    
      
  end
end