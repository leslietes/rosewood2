class Checkin < ActiveRecord::Base
  
  belongs_to :room
  belongs_to :occupant
  
  def self.get_all
    Checkin.includes(:room,:occupant).order("rooms.room_no ASC, occupants.last_name, occupants.first_name")
  end
    
end
