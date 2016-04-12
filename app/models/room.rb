class Room < ActiveRecord::Base
  validates :room_no,       presence: true
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
end
