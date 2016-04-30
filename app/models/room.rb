class Room < ActiveRecord::Base
  validates :room_no,       presence: true, uniqueness:   true
  validates :max_occupants, presence: true, numericality: true
  validates :room_rate,     presence: true, numericality: true
  
  has_many :checkins
  has_many :occupants, through: :checkin_occupants
  has_many :checkin_occupants
  
  has_many :notices
  
  def self.all_vacant
    where(occupied: false).order("room_no")
  end
  
  def self.unoccupied
    # do not reverse order of pluck - for select_tag
    where(occupied: false, active: true).pluck(:room_no, :id)
  end
  
  def self.occupied!(room_id)
    find(room_id).update(occupied: 1)
  end
  
  def self.vacated!(room_id)
    find(room_id).update(occupied: 0)
  end
  
  def self.occupancy_list
    Room.where(active: true).includes(checkins: {:checkin_occupants => :occupant}).order(room_no: :asc)
  end
  
  def self.vacancy_list
    Room.find_by_sql("select rooms.room_no,
                             'VACANT' as moveout_date,
                             '' as checkin_id,
                             '' as notice_id,
                             'false' as checkin
                        from rooms
                       where rooms.active = 1 and
                             rooms.occupied = 0
                       UNION
                      select checkins.room_no,
                             notices.moveout_date,
                             checkins.id as checkin_id,
                             notices.id as notice_id,
                             'true' as checkin
                        from checkins,
                             notices
                       where checkins.id = notices.checkin_id
                    order by room_no;")
  end
  
  def self.room_no(room_id)
    find(room_id).room_no
  end
  
  def self.room_rate(room_id)
    find(room_id).room_rate
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
