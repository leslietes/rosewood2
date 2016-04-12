class Occupant < ActiveRecord::Base
  
  validates :first_name, presence: true
  
  def name
    "#{last_name}, #{first_name}"
  end
end
