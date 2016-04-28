# spec/models/occupant.rb
#require 'rails_helper'

describe Occupant do
  it "has a valid factory" do
    occupant = FactoryGirl.create(:occupant)
    expect(occupant).to be_valid
  end
  
  it "is invalid without a first_name" do
    occupant = FactoryGirl.build(:occupant, first_name: nil)
    expect(occupant).to be_invalid  
  end
  
  it "is invalid wihtout a last_name" do
    occupant = FactoryGirl.build(:occupant, last_name: nil)
    expect(occupant).to be_invalid  
  end
  
  describe "create occupant data" do
    before :each do
      @occupant = FactoryGirl.create(:occupant)
    end
    
    it "returns people waiting for a room" do
      Occupant.waiting_for_room.size.should be 1    
    end
  
    it "checks in occupant" do
      Occupant.checked_in!(@occupant.id)
      @occupant.reload
      Occupant.waiting_for_room.size.should be 0
    end
        
    it "returns an occupant's full name as a string" do
      expect(@occupant.to_s) == "#{@occupant.first_name} #{@occupant.last_name}"  
    end
  
    it "returns an occupant's address as a string" do
      expect(@occupant.address) == "7 Washington Avenue, Riverwood, NSW 2210"
    end
    
    it "returns an occupants age as an integer" do
      expect(@occupant.age) == "21 years old"
    end
    
    it "it sets occupant status to inactive" do
      expect(@occupant.inactive!) == true
      expect(@occupant.active) == false
    end
  end
  
end