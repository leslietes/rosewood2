class BillingDetail < ActiveRecord::Base
  belongs_to :billing
  belongs_to :checkin
  has_many   :billing_utilities
  has_many   :occupants, through: :billing_occupants
  has_many   :billing_occupants
  
  
  BASIC=['Water','Electricity']
  
  def add_billing_utility(utility_id, user_id)
    utility = Utility.find(utility_id)
    billing_utilities.create(utility_name: utility.name, rate:utility.first_rate, amount:utility.first_rate, billing_id: billing.id, user_id: user_id)
  end
  
end
