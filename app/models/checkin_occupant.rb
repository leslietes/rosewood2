class CheckinOccupant < ActiveRecord::Base
  belongs_to :checkin
  belongs_to :occupant
end