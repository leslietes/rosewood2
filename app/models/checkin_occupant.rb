class CheckinOccupant < ActiveRecord::Base
  belongs_to :checkin
  belongs_to :occupant
  
  def vacate_room!
    update(end_date: Date.today)  
  end
  
  #def still_checked_in?
  #  return true if end_date.nil?
  #  return false
  #end
end