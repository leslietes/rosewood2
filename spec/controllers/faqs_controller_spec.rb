describe FaqsController do
  
  context "index page" do
    it "index requires authenticated user" do
      get :index
      response.should render_template :index
    end
  
    it "index populates array of faqs" do
      faq = FactoryGirl.create(:faq)
      get :index
      assigns(:faqs).should eq([faq])
    end
  end
  
  context "show page" do
    it "show does not require authenticated user" do
      faq = FactoryGirl.create(:faq)
      get :show, id: faq.id
      response.should redirect_to faqs_url
    end
  end
  
  it "new requires authenticated user" do
    get :new
    response.should redirect_to new_user_session_url
  end
  
  it "edit requires authenticated user" do
    faq = FactoryGirl.create(:faq)
    get :edit, id: faq.id
    response.should redirect_to new_user_session_url
  end
  
  it "delete requires authenticated user" do
    faq = FactoryGirl.create(:faq)
    get :destroy, id: faq.id
    response.should redirect_to new_user_session_url
  end

  describe "sign in user" do
    before :each do
      @user = FactoryGirl.create(:user)
      @ufaq = FactoryGirl.create(:faq)
      sign_in :user, @user
    end
    
    context "new page" do
      it "renders the :new view" do
        get :new
        response.should render_template :new
      end
    end
    
    context "edit page" do
      it "renders the :edit view" do
        @faq = FactoryGirl.create(:faq)
        get :edit, id: @faq
        response.should render_template :edit
      end
    end
    
    context "create page with valid attributes" do
      it "creates a new faq" do
        expect {
          post :create, faq: FactoryGirl.attributes_for(:faq)
        }.to change(Faq,:count).by(1)
      end
    
      it "redirects to index page after create" do
        post :create, faq: FactoryGirl.attributes_for(:faq)
        response.should redirect_to faqs_url
      end
    end
    
    context "create page with invalid attributes" do
      it "renders new page on create error" do
        post :create, faq: FactoryGirl.attributes_for(:invalid_faq)
        response.should render_template :new
      end
      
      it "does not save new faq" do
        expect {
          post :create, faq: FactoryGirl.attributes_for(:invalid_faq)
        }.to_not change(Faq,:count)
      end
    end
    
    context "update page with valid attributes" do
      before :each do
        @faq = FactoryGirl.create(:faq)
      end
      
      it "locates the requested faq" do
        put :update, id: @faq, faq: FactoryGirl.attributes_for(:faq)
        assigns(:faq).should eq(@faq)
      end
      
      it "changes faq attribute" do
        put :update, id: @faq, faq: FactoryGirl.attributes_for(:faq, question: "What?")
        @faq.reload
        @faq.question.should eq("What?")
      end
      
      it "redirects to updated faq" do
        put :update, id: @faq, faq: FactoryGirl.attributes_for(:faq)
        response.should redirect_to faqs_url
      end
    end
    
    context "update page with invalid attributes" do
      before :each do
        @faq = FactoryGirl.create(:faq)
      end
      
      it "locates the requested faq" do
        put :update, id: @faq, faq: FactoryGirl.attributes_for(:invalid_faq)
        assigns(:faq).should eq(@faq)
      end
      
      it "does not change faq's attributes" do
        put :update, id: @faq, faq: FactoryGirl.attributes_for(:invalid_faq)
        @faq.reload
        @faq.question.should_not eq("")
        @faq.answer.should_not eq("")
      end
      
      it "renders the edit page" do
        put :update, id: @faq, faq: FactoryGirl.attributes_for(:invalid_faq)
        response.should render_template :edit
      end
    end
    
    context "destroy page" do
      before :each do
        @faq = FactoryGirl.create(:faq)  
      end
      
      it "deletes the faq" do
        expect{
          delete :destroy, id: @faq
        }.to change(Faq,:count).by(-1)
      end
      
      it "redirects to index page" do
        delete :destroy, id: @faq
        response.should redirect_to faqs_url
      end
    end   
  end
end