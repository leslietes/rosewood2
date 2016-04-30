class Reservation < ActiveRecord::Base
  validates :name,        presence: true
  validates :movein_date, presence: true
  
  belongs_to :room
end
