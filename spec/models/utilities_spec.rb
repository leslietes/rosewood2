describe Utility do
  it "has a valid factory" do
    utility = FactoryGirl.create(:utility)
    expect(utility).to be_valid
  end
  
  it "is invalid without a name" do
    utility = FactoryGirl.build(:utility, name: nil)
    expect(utility).to be_invalid  
  end
  
  it "is invalid wihtout a category" do
    utility = FactoryGirl.build(:utility, category: nil)
    expect(utility).to be_invalid  
  end
  
  it "return basic utilities" do
    FactoryGirl.create(:utility)
    Utility.basic.count.should be 1
  end
  
  it "return extra utilities" do
    FactoryGirl.create(:extra)
    Utility.extras.count.should be 1
  end 
end