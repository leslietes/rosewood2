describe Faq do
  it "has a valid factory" do
    faq = FactoryGirl.create(:faq)
    expect(faq).to be_valid
  end
  
  it "is invalid without a question" do
    faq = FactoryGirl.build(:faq, question: nil)
    expect(faq).to be_invalid  
  end
  
  it "is invalid wihtout an answer" do
    faq = FactoryGirl.build(:faq, answer: nil)
    expect(faq).to be_invalid  
  end
end