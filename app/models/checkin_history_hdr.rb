class CheckinHistoryHdr < ActiveRecord::Base
  has_many :checkin_history_dtls
end
