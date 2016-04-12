class Occupant < ActiveRecord::Base
  
  validates :first_name, presence: true
  
  has_many :checkins
  has_many :rooms, through: :checkins
  
  def self.waiting_for_room
    select(:id, :last_name, :first_name).where(waiting: true)
  end
  
  def name
    "#{last_name}, #{first_name}"
  end
end
