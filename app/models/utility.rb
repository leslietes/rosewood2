class Utility < ActiveRecord::Base
  
  validates :name, presence: true
  validates :category, presence: true
  
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
end
