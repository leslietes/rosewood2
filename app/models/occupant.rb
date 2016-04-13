class Occupant < ActiveRecord::Base
  
  has_attached_file :photo, :styles => {:medium => "192x192#", :small => "95x95#"}
    
  validates_attachment_content_type :photo, :content_type => ["image/jpg","image/jpeg","image/png","image/gif"]
  
  validates :first_name, presence: true
  
  has_many :checkins
  has_many :rooms, through: :checkins
  
  def self.waiting_for_room
    select(:id, :last_name, :first_name).where(waiting: true)
  end
  
  def self.not_waiting(occupant_id)
    find(occupant_id).update(waiting: false)
  end
  
  def name
    "#{last_name}, #{first_name}"
  end
  
  def address
    # remove blank fields then join with comma
    [address1,address2,city,province].reject(&:blank?).join(", ")
  end
  
  def age
    return "" if birthdate.blank?
    "(#{Date.today.year - birthdate.year} years old)" 
  end
end
