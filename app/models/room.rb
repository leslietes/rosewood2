class Room < ActiveRecord::Base
  validates :room_no,       presence: true, uniqueness:   true
  validates :max_occupants, presence: true, numericality: true
  validates :room_rate,     presence: true, numericality: true
  
  has_many :checkins
  has_many :occupants, through: :checkin_occupants
  
  def self.unoccupied
    # do not reverse order of pluck - for select_tag
    where(occupied: false).pluck(:room_no, :id)
  end
  
  def self.occupied!(room_id)
    find(room_id).update(occupied: 1)
  end
  
  def self.occupancy_list
    #Room.includes(:checkins,:occupants)
    Room.find_by_sql("select rooms.id, 
                             rooms.room_no, 
                             IFNULL(occupants.last_name,'VACANT') as last_name,
                             occupants.first_name as first_name,
                             checkins.id as _id, 
                             checkin_occupants.start_date as _date 
                       from rooms 
                       left join checkins on rooms.id = checkins.room_id 
                       left join checkin_occupants on checkins.id = checkin_occupants.checkin_id
                       left join occupants on checkin_occupants.occupant_id = occupants.id
                   order by rooms.room_no, occupants.last_name, occupants.first_name ;")
  end
  
  def start_date
    if checkins.blank?
      return ''
    else
      checkins.first.start_date
    end
  end
  
  def has_checkin?
    return false if checkins.blank?
    return true
  end
end
