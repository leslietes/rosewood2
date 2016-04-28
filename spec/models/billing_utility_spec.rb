describe BillingUtility do
  
    it "gets electricity" do    
      billing = FactoryGirl.create(:billing)
      water   = FactoryGirl.create(:utility)
      elec    = FactoryGirl.create(:electricity)
    
      detail = billing.billing_details.create(user_id: 1, room_no: 101, checkin_id: 1)

      detail.add_billing_utility(water.id, 1)
      detail.add_billing_utility(elec.id,  1)
    
      expect BillingUtility.get_electricity(billing.id).count.should eq (1)
    end
  
    it "gets water" do
      billing = FactoryGirl.create(:billing)
      water   = FactoryGirl.create(:utility)
      elec    = FactoryGirl.create(:electricity)
      
      detail = billing.billing_details.create(user_id: 1, room_no: 101, checkin_id: 1)

      detail.add_billing_utility(water.id, 1)
      detail.add_billing_utility(elec.id,  1)
      
      expect BillingUtility.get_water(billing.id).count.should eq (1)
    end
  
    it "calculates electricity" do
      billing = FactoryGirl.create(:billing)
      elec    = FactoryGirl.create(:electricity)
      
      detail = billing.billing_details.create(user_id: 1, room_no: 101, checkin_id: 1)
      
      utility= detail.add_billing_utility(elec.id,  1)
      utility.update(from: 5, to:10)
      utility.calculate_electricity
      
      expect utility.amount.should eq 55
    end
  
    it "calculates water when within limits" do
      billing = FactoryGirl.create(:billing)
      water   = FactoryGirl.create(:utility)
      
      detail = billing.billing_details.create(user_id: 1, room_no: 101, checkin_id: 1)
      
      utility = detail.add_billing_utility(water.id,  1)
      utility.update(from: 5, to:10)
      utility.calculate_water
      
      expect utility.amount.should eq 150
    end
  
    it "calculates water when over limit" do
      billing = FactoryGirl.create(:billing)
      water   = FactoryGirl.create(:utility)
      
      detail = billing.billing_details.create(user_id: 1, room_no: 101, checkin_id: 1)
      
      utility = detail.add_billing_utility(water.id,1)
      utility.update(from: 5, to:30)
      utility.calculate_water
      
      expect utility.amount.should eq 450
    end
  
    it "removes billing utility" do
      billing = FactoryGirl.create(:billing)
      water   = FactoryGirl.create(:utility)
      
      detail = billing.billing_details.create(user_id: 1, room_no: 101, checkin_id: 1)
      
      utility = detail.add_billing_utility(water.id,1)
      
      expect detail.billing_utilities.count.should eq 1
      
      utility.remove!
      
      expect detail.billing_utilities.count.should eq 0
    end

end