class Room < ActiveRecord::Base
  validates :room_no,       presence: true, uniqueness:   true
  validates :max_occupants, presence: true, numericality: true
  validates :room_rate,     presence: true, numericality: true
  
  has_many :checkins
  has_many :occupants, through: :checkins
  
  def self.not_full
    # do not reverse order of pluck - for select_tag
    where(full: false).pluck(:room_no, :id)
  end
  
  def self.update_status(room_id, full_flag)
    find(room_id).update(full: full_flag)
  end
  
  def self.occupancy_list
    Room.find_by_sql("select rooms.id, 
                             rooms.room_no, 
                             occupants.last_name as last_name,
                             occupants.first_name as first_name, 
                             checkins.start_date as start_date 
                        from rooms 
                   left join checkins on rooms.id = checkins.room_id 
                   left join occupants on checkins.occupant_id = occupants.id
               order by rooms.room_no, occupants.last_name, occupants.first_name ;")
  end
  
  # for occupancy list report
  def occupant_or_vacant
    last_name.blank? ? 'VACANT' : "#{first_name} #{last_name}"
  end
end
