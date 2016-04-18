class CheckinDetail < ActiveRecord::Base
  belongs_to :checkin
  belongs_to :utility
  
  def remove!
    destroy
  end
end
