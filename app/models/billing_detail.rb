class BillingDetail < ActiveRecord::Base
  belongs_to :billing
  belongs_to :checkin
  has_many   :billing_utilities
  has_many   :occupants, through: :checkin_occupants
  has_many   :checkin_occupants
  
  
  BASIC=['Water','Electricity']
  
end
