class Utility < ActiveRecord::Base
  
  has_many :checkin_details
  
  CATEGORIES = ["Basic","Extra"]
  
  def self.basic
    # basic or extra
    where(category: 'Basic')
  end
  
  def self.extras
    # basic or extra
    where(category: 'Extra')
  end

  def to_s
    name
  end
end
