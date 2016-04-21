class Checkin < ActiveRecord::Base
  belongs_to :room
  belongs_to :occupant
  
  has_many   :utilities, through: :checkin_details
  has_many   :checkin_details
  has_many   :occupants, through: :checkin_occupants
  has_many   :checkin_occupants
  
  
  def self.find_by_room(room_id)
    where("checkout = FALSE AND room_id= :room_id",{ room_id: room_id })
  end
    
  def self.get_details(checkin_id)
    find_by_sql("select checkins.id, 
                        checkins.room_id,
                        checkins.checkout, 
                        checkins.start_date as start_date, 
                        checkins.end_date, 
                        rooms.room_no,
                        checkin_occupants.occupant_id, 
                        checkin_occupants.start_date as _sdate, 
                        checkin_occupants.end_date as _edate, 
                        occupants.first_name,
                        occupants.last_name 
                   from checkins, 
                        rooms,
                        checkin_occupants, 
                        occupants 
                  where checkins.id = checkin_occupants.checkin_id and 
                        checkin_occupants.occupant_id = occupants.id and
                        checkins.room_id = rooms.id and
                        checkins.id = #{checkin_id};" )
    
  end
  
  def vacate!
    # move checkin to checkinhistoryhdr
    hdr = CheckinHistoryHdr.create(room_id: room_id, start_date: start_date, end_date: Date.today, room_no: room_no)
    # move occupants to checkinhistorydtl
    checkin_occupants.each { |o| CheckinHistoryDtl.create(checkin_history_hdr_id: hdr.id, occupant_id: o.occupant_id, start_date: o.start_date, end_date: o.end_date) }
    # delete all occupants
    checkin_occupants.delete_all
    # delete all utilities - no history
    checkin_details.delete_all
    # delete checkin date
    destroy
  end
  
  def transfer_room(new_room_id)
    room = Room.room_no(new_room_id)
    update(room_id: new_room_id, room_no: room.room_no)
  end
end
