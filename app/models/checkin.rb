class Checkin < ActiveRecord::Base
  
  belongs_to :room
  belongs_to :occupant
  
  def self.get_all
    Checkin.include(:rooms,:occupants)
  end
    
end
