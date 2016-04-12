class Room < ActiveRecord::Base
  validates :room_no,       presence: true
  validates :max_occupants, presence: true, numericality: true
  validates :room_rate,     presence: true, numericality: true
end
