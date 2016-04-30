class Notice < ActiveRecord::Base
  validates :moveout_date, presence: true
  validates :reason,       presence: true
  validates :date_received,presence: true
  
  belongs_to :checkin
end
