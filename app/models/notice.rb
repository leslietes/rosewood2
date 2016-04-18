class Notice < ActiveRecord::Base
  validates :room_no,   presence: true
  
  belongs_to :room
  
  #def self.notice_to_vacate_list
    # includes all VACANT rooms plus those with notices/reservations
    #  Notice.find_by_sql("select rooms.id, 
    #                             rooms.room_no, 
    #                             notices.occupants,
    #                             notices.reason,
    #                             notices.move_out_date,
    #                             notices.date_received,
    #                             notices.proposed_occupants,
    #                             notices.checkin_date,
    #                             notices.paid
    #                        from rooms 
    #                        left join notices on rooms.room_no = notices.room_no
    #                       where rooms.occupied = false
    #                order by rooms.room_no;")
  #end
  
  def self.all_current
    where("move_out_date > #{Date.today} or checkin_date > #{Date.today}").order("room_no")
  end
  
end
