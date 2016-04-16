describe UtilitiesController do
  
  it "index requires authenticated user" do
    get :index
    response.should redirect_to new_user_session_url
  end
  
  it "new requires authenticated user" do
    get :new
    response.should redirect_to new_user_session_url
  end
  
  it "show requires authenticated user" do
    utility = FactoryGirl.create(:utility)
    get :show, id: utility.id
    response.should redirect_to new_user_session_url
  end

  it "edit requires authenticated user" do
    utility = FactoryGirl.create(:utility)
    get :edit, id: utility.id
    response.should redirect_to new_user_session_url
  end
  
  it "delete requires authenticated user" do
    utility = FactoryGirl.create(:utility)
    get :destroy, id: utility.id
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
        utility = FactoryGirl.create(:utility)
        get :index
        assigns(:utilities).should eq([utility])
      end
    end
    
    context "show page" do
      it "renders the :show view" do
        @utility = FactoryGirl.create(:utility)
        get :show, id: @utility
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
        @utility = FactoryGirl.create(:utility)
        get :edit, id: @utility
        response.should render_template :edit
      end
    end
    
    context "create page with valid attributes" do
      it "creates a new utility" do
        expect {
          post :create, utility: FactoryGirl.attributes_for(:utility)
        }.to change(Utility,:count).by(1)
      end
    
      it "redirects to index page after create" do
        post :create, utility: FactoryGirl.attributes_for(:utility)
        response.should redirect_to utilities_url
      end
    end
    
    context "create page with invalid attributes" do
      it "renders new page on create error" do
        post :create, utility: FactoryGirl.attributes_for(:invalid_utility)
        response.should render_template :new
      end
      
      it "does not save new utility" do
        expect {
          post :create, utility: FactoryGirl.attributes_for(:invalid_utility)
        }.to_not change(Utility,:count)
      end
    end
    
    context "update page with valid attributes" do
      before :each do
        @utility = FactoryGirl.create(:utility)
      end
      
      it "locates the requested utility" do
        put :update, id: @utility, utility: FactoryGirl.attributes_for(:utility)
        assigns(:utility).should eq(@utility)
      end
      
      it "changes utility attribute" do
        put :update, id: @utility, utility: FactoryGirl.attributes_for(:utility, name: "Cable TV Subscription")
        @utility.reload
        @utility.name.should eq("Cable TV Subscription")
      end
      
      it "redirects to updated utility" do
        put :update, id: @utility, utility: FactoryGirl.attributes_for(:utility)
        response.should redirect_to utilities_url
      end
    end
    
    context "update page with invalid attributes" do
      before :each do
        @utility = FactoryGirl.create(:utility)
      end
      
      it "locates the requested utility" do
        put :update, id: @utility, utility: FactoryGirl.attributes_for(:invalid_utility)
        assigns(:utility).should eq(@utility)
      end
      
      it "does not change utility's attributes" do
        put :update, id: @utility, utility: FactoryGirl.attributes_for(:invalid_utility)
        @utility.reload
        @utility.name.should_not eq("")
      end
      
      it "renders the edit page" do
        put :update, id: @utility, utility: FactoryGirl.attributes_for(:invalid_utility)
        response.should render_template :edit
      end
    end
    
    context "destroy page" do
      before :each do
        @utility = FactoryGirl.create(:utility)  
      end
      
      it "deletes the utility" do
        expect{
          delete :destroy, id: @utility
        }.to change(Utility,:count).by(-1)
      end
      
      it "redirects to index page" do
        delete :destroy, id: @utility
        response.should redirect_to utilities_url
      end
    end     
  end
end