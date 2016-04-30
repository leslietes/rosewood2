class BillingOccupant < ActiveRecord::Base
  belongs_to :billing_detail
  belongs_to :occupant
end
