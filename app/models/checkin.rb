class Checkin < ActiveRecord::Base
  
  belongs_to :room
  belongs_to :occupant
    
end
